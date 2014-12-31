//
//  CamCaptureViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

static void *CapturingStillImageContext = &CapturingStillImageContext;
static void *RecordingContext = &RecordingContext;
static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface CamCaptureViewController () < AVCaptureFileOutputRecordingDelegate, CamCaptureModeViewControllerDelegate, CamCaptureOverlayViewControllerDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *overlayContainer;
@property (weak, nonatomic) IBOutlet AVCamPreviewView *previewView;
@property (weak, nonatomic) IBOutlet UIView *curtainContainer;
@property (weak, nonatomic) IBOutlet UIView *modeContainer;

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingId;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) id runtimeErrorHandlingObserver;
@property (assign, nonatomic) NSUInteger currentPageIndex;

@end

@implementation CamCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        __weak CamCaptureViewController *weakSelf = self;
        [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
            CamCaptureViewController *strongSelf = weakSelf;
            dispatch_async([strongSelf sessionQueue], ^{
                [[strongSelf session] startRunning];
            });
        }]];
        [[self session] startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.curtainViewController openCurtainWithCompletionHandler:nil];
        });
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.curtainViewController openCurtainWithCompletionHandler:^{
        dispatch_async([self sessionQueue], ^{
            [[self session] stopRunning];
            [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
            [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        });
    }];
}

- (void)setupViews
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
    self.modeViewController.delegate = self;
    self.overlayViewController.delegate = self;
}

- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == SessionRunningAndDeviceAuthorizedContext) {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRunning) {
            } else {
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setupCaptureSession
{
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];

    // Setup the preview view
    [[self previewView] setSession:session];
    [((AVCaptureVideoPreviewLayer *)[[self previewView] layer]) setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(self.sessionQueue, ^{
        [self setBackgroundRecordingId:UIBackgroundTaskInvalid];
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        if ([self.session canAddInput:videoDeviceInput]) {
            [self.session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            [self setFlashMode:self.overlayViewController.flashMode forDevice:videoDevice];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
            });
        }
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
        
        if ([self.session canAddInput:audioDeviceInput]) {
            [self.session addInput:audioDeviceInput];
        }
        
        [self setupStillFileOutput];
    });
}

- (void)setupMovieFileOutput
{
    [self.session beginConfiguration];
    if (self.movieFileOutput) {
        [self.session removeOutput:self.movieFileOutput];
        [self setMovieFileOutput:nil];
    }
    AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:movieFileOutput]) {
        [self.session addOutput:movieFileOutput];
        [self setMovieFileOutput:movieFileOutput];
    }
    [self.session commitConfiguration];
}

- (void)setupStillFileOutput
{
    [self.session beginConfiguration];
    if (self.stillImageOutput) {
        [self.session removeOutput:self.stillImageOutput];
        [self setStillImageOutput:nil];
    }

    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.session canAddOutput:stillImageOutput]) {
        [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [self.session addOutput:stillImageOutput];
        [self setStillImageOutput:stillImageOutput];
    }
    [self.session commitConfiguration];
}

#pragma CamScrollView Action
- (void)didPicGalleryButtonClicked:(id)sender
{
}

- (void)didVideoGalleryButtonClicked:(id)sender
{
}

- (void)didStillCaptureButtonClicked:(id)sender
{
    [self.overlayViewController enableButtons:NO];
    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        dispatch_async([self sessionQueue], ^{
            [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
            [self setFlashMode:self.overlayViewController.flashMode forDevice:[[self videoDeviceInput] device]];
            [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if (imageDataSampleBuffer) {
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    NSLog(@"%@", NSStringFromCGSize(image.size));
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.curtainViewController openCurtainWithCompletionHandler:^{
                            [self.overlayViewController enableButtons:YES];
                        }];
                    });
                }
            }];
        });
    }];
}

- (void)startRecording
{
    [NSThread detachNewThreadSelector:nil toTarget:nil withObject:nil];
    [NSThread exit];
    [self.overlayViewController enableButtons:NO];
//    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording]) {
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                [self setBackgroundRecordingId:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
            }
            [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
            [self setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
    });
}

- (void)stopRecording
{
    [self.overlayViewController enableButtons:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.recordingTimer invalidate];
//        self.recordingTimer = nil;
//        [self.progressView startAnimation];
    });
    
    dispatch_async([self sessionQueue], ^{
        if ([[self movieFileOutput] isRecording]) {
            [[self movieFileOutput] stopRecording];
        }
    });
}
#pragma mark CamCaptureOverlayViewController
- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didCloseButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didNextButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didFlashButtonClicked:(id)sender
{
    [controller enableButtons:NO];
    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        dispatch_async([self sessionQueue], ^{
            [[self session] beginConfiguration];
            AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
            [self setFlashMode:self.overlayViewController.flashMode forDevice:currentVideoDevice];
            [[self session] commitConfiguration];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.curtainViewController openCurtainWithCompletionHandler:^{
                    [controller enableButtons:YES];
                }];
            });
        });
    }];
}

- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didGridButtonClicked:(id)sender
{

}

- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didRotateButtonClicked:(id)sender
{
    [controller enableButtons:NO];
    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        dispatch_async([self sessionQueue], ^{
            AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
            AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
            AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
            switch (currentPosition)
            {
                case AVCaptureDevicePositionUnspecified:
                    preferredPosition = AVCaptureDevicePositionBack;
                    break;
                case AVCaptureDevicePositionBack:
                    preferredPosition = AVCaptureDevicePositionFront;
                    break;
                case AVCaptureDevicePositionFront:
                    preferredPosition = AVCaptureDevicePositionBack;
                    break;
            }
            AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
            AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
            [[self session] beginConfiguration];
            [[self session] removeInput:[self videoDeviceInput]];
            if ([[self session] canAddInput:videoDeviceInput]) {
                [self setFlashMode:self.overlayViewController.flashMode forDevice:videoDevice];
                [[self session] addInput:videoDeviceInput];
                [self setVideoDeviceInput:videoDeviceInput];
            } else {
                [[self session] addInput:[self videoDeviceInput]];
            }
            
            [[self session] commitConfiguration];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.curtainViewController openCurtainWithCompletionHandler:^{
                    [controller enableButtons:YES];
                }];
            });
        });
    }];
}

#pragma mark CamCaptureModeViewControllerDelegate
- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didEndDisplayingPageAtIndex:(NSInteger)pageIndex
{
    if (self.currentPageIndex == pageIndex) {
        return;
    }
    
    self.currentPageIndex = pageIndex;
    
    if (pageIndex == 1) {
        dispatch_async(self.sessionQueue, ^{
            [self setupMovieFileOutput];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.curtainViewController openCurtainWithCompletionHandler:^{
                    [self.overlayViewController didEndTransitionToPageIndex:pageIndex];
                }];
            });
        });
    } else {
        dispatch_async(self.sessionQueue, ^{
            [self setupStillFileOutput];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.curtainViewController openCurtainWithCompletionHandler:^{
                    [self.overlayViewController didEndTransitionToPageIndex:pageIndex];
                }];
            });
        });
    }
}

- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didScrollWithPercentage:(CGFloat)percentage toPage:(NSUInteger)pageIndex
{
    [self.curtainViewController openCurtainWithPercent:percentage];
    [self.overlayViewController transitionWithPercent:percentage toPageIndex:pageIndex];
}

#pragma mark Device Configuration
- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            [self setDeviceAuthorized:YES];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:GET_STRING(@"cam_auth_title") message:GET_STRING(@"cam_auth_msg") delegate:self cancelButtonTitle:GET_STRING(@"ok") otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    });
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark File Output Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
    }
    
    [self.overlayViewController enableButtons:NO];
    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingId];
        [self setBackgroundRecordingId:UIBackgroundTaskInvalid];
        [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
            [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
            if (backgroundRecordingID != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.curtainViewController openCurtainWithCompletionHandler:^{
                    [self.overlayViewController enableButtons:YES];
                }];
            });
        }];
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CamCaptureOverlayViewControllerSegueIdentifier]) {
        self.overlayViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CamCaptureModeViewControllerSegueIdentifier]) {
        self.modeViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CamCurtainViewControllerSegueIdentifier]) {
        self.curtainViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

@end
