//
//  CamCaptureViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "CamCaptureViewController.h"
#import "AssetsPickerViewController.h"

#define Max_Record_Duration 10.0f
static void *CapturingStillImageContext = &CapturingStillImageContext;
static void *RecordingContext = &RecordingContext;
static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;
static void *AssetsCollectorIsReadyContext = &AssetsCollectorIsReadyContext;

@interface CamCaptureViewController () < AVCaptureFileOutputRecordingDelegate, CamCaptureModeViewControllerDelegate, CamCaptureOverlayViewControllerDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;

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
@property (strong, nonatomic) NSCondition *condition;
@property (strong, nonatomic) NSThread *recordThread;

@end

@implementation CamCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupCaptureSession];
    [self setupRecordThread];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAssets];
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
        self.currentPageIndex == 0 ? [self setupStillFileOutput] : [self setupMovieFileOutput];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.curtainViewController openCurtainWithCompletionHandler:nil];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ELCAssetsCollector sharedInstance] removeObserver:self forKeyPath:@"isReady"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.recordThread cancel];
    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        dispatch_async([self sessionQueue], ^{
            [[self session] beginConfiguration];
            if (self.stillImageOutput) {
                [[self session] removeOutput:self.stillImageOutput];
                [self setStillImageOutput:nil];
            }
            
            if (self.movieFileOutput) {
                [[self session] removeOutput:self.movieFileOutput];
                [self removeObserver:self forKeyPath:@"movieFileOutput.recording"];
                [self setMovieFileOutput:nil];
            }
            
            [[self session] commitConfiguration];
            [[self session] stopRunning];
            [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
            [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        });
    }];
}

- (void)dealloc
{
//    [[ELCAssetsCollector sharedInstance] removeObserver:self forKeyPath:@"isReady"];
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
    } else if (context == RecordingContext) {
        BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
        if (isRecording) {
            [self.condition lock];
            [self.condition signal];
            [self.condition unlock];
        } else {
            
        }
    } else if (context == AssetsCollectorIsReadyContext) {
        if ([change[NSKeyValueChangeNewKey] boolValue]) {
            if ([ELCAssetsCollector sharedInstance].mode == kAssetsPickerModePhoto) {
                if ([[ELCAssetsCollector sharedInstance] isAuthorized] && [ELCAssetsCollector sharedInstance].assetGroups.count > 0) {
                    ALAssetsGroup *group = (ALAssetsGroup *)[ELCAssetsCollector sharedInstance].assetGroups[0];
                    UIImage *posterImage = [UIImage imageWithCGImage:[group posterImage]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.modeViewController.scrollView.picGalleryButton setImage:posterImage forState:UIControlStateNormal];
                    });
                }
            } else {
                if ([[ELCAssetsCollector sharedInstance] isAuthorized] && [ELCAssetsCollector sharedInstance].assetGroups.count > 0) {
                    ALAssetsGroup *group = (ALAssetsGroup *)[ELCAssetsCollector sharedInstance].assetGroups[0];
                    UIImage *posterImage = [UIImage imageWithCGImage:[group posterImage]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.modeViewController.scrollView.videoGalleryButton setImage:posterImage forState:UIControlStateNormal];
                        [ELCAssetsCollector sharedInstance].mode = kAssetsPickerModePhoto;
                    });
                }
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark Setup
- (void)setupViews
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
    self.modeViewController.delegate = self;
    self.overlayViewController.delegate = self;
}

- (void)setupRecordThread
{
    self.condition = [[NSCondition alloc] init];
    self.recordThread = [[NSThread alloc] initWithTarget:self selector:@selector(recordThreadRoutine) object:nil];
    [self.recordThread start];
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
        [self removeObserver:self forKeyPath:@"movieFileOutput.recording"];
        [self setMovieFileOutput:nil];
    }
    AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    movieFileOutput.maxRecordedDuration = CMTimeMakeWithSeconds(10.0, 1);
    if ([self.session canAddOutput:movieFileOutput]) {
        [self.session addOutput:movieFileOutput];
        [self setMovieFileOutput:movieFileOutput];
        [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
    }
    [self.session commitConfiguration];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.overlayViewController updateProgress:0];
    });
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

- (void)setupAssets
{
    [[ELCAssetsCollector sharedInstance] addObserver:self forKeyPath:@"isReady" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:AssetsCollectorIsReadyContext];
    [ELCAssetsCollector sharedInstance].mode = kAssetsPickerModeVideo;
}

- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

- (void)recordThreadRoutine
{
    NSAssert([NSThread currentThread] != [NSThread mainThread], @"Should not be main thread");
    while ([NSThread currentThread].isCancelled == NO) {
        [self.condition lock];
        while ([[self movieFileOutput] isRecording]) {
            double duration = CMTimeGetSeconds([[self movieFileOutput] recordedDuration]);
            double time = Max_Record_Duration;
            CGFloat progress = (CGFloat) (duration / time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.overlayViewController updateProgress:progress];
            });
        }
        [self.condition wait];
        [self.condition unlock];
    }
}

#pragma CamScrollView Action
- (void)didPicGalleryButtonClicked:(id)sender
{
    AssetsPickerViewController *assetsPickerViewController = (AssetsPickerViewController *)[[UIStoryboard storyboardWithName:@"Cam" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:AssetsPickerViewControllerIdentifier];
    assetsPickerViewController.mode = kAssetsPickerModePhoto;
    [assetsPickerViewController view];

    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        [self.navigationController pushViewController:assetsPickerViewController animated:YES];
    }];
}

- (void)didVideoGalleryButtonClicked:(id)sender
{
    AssetsPickerViewController *assetsPickerViewController = (AssetsPickerViewController *)[[UIStoryboard storyboardWithName:@"Cam" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:AssetsPickerViewControllerIdentifier];
    assetsPickerViewController.mode = kAssetsPickerModeVideo;
    [assetsPickerViewController view];
    [self.curtainViewController closeCurtainWithCompletionHandler:^{
        [self.navigationController pushViewController:assetsPickerViewController animated:YES];
    }];
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
    [self.overlayViewController enableButtons:NO];
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
            dispatch_async([self sessionQueue], ^{
                [self setupMovieFileOutput];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.curtainViewController openCurtainWithCompletionHandler:^{
                        [self.overlayViewController enableButtons:YES];
                    }];
                });
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
