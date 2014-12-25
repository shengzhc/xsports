//
//  AVCamViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "CamViewController.h"
#import "AVCamPreviewView.h"
#import "CamScrollView.h"
#import "ProgressView.h"

static void *CapturingStillImageContext = &CapturingStillImageContext;
static void *RecordingContext = &RecordingContext;
static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface CamViewController () <AVCaptureFileOutputRecordingDelegate, UIScrollViewDelegate>

// For use in the storyboards.
@property (nonatomic, weak) IBOutlet AVCamPreviewView *previewView;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;
@property (weak, nonatomic) IBOutlet UIView *toolContainer;
@property (weak, nonatomic) IBOutlet CamScrollView *camScrollView;
@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flashButtonTrailConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gridButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainVerticalConstraint;

@property (assign, nonatomic) AVCaptureFlashMode flashMode;
@property (strong, nonatomic) NSTimer *recordingTimer;

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer;

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingId;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;
@property (assign, nonatomic) NSInteger lastPageIndex;

@end

@implementation CamViewController

- (BOOL)isSessionRunningAndDeviceAuthorized
{
	return [[self session] isRunning] && [self isDeviceAuthorized];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setupConstraints];
    [self setupCamScrollView];
    [self setupCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        __weak CamViewController *weakSelf = self;
        [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
            CamViewController *strongSelf = weakSelf;
            dispatch_async([strongSelf sessionQueue], ^{
                [[strongSelf session] startRunning];
            });
        }]];
        [[self session] startRunning];
        [self openCurtainWithCompletionHandler:nil];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    dispatch_async([self sessionQueue], ^{
        [[self session] stopRunning];
        [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
    });
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

#pragma mark Setup
- (void)setupConstraints
{
    self.toolBarTopConstraint.constant = self.view.bounds.size.width + 44.0;
    self.gridButtonLeadingConstraint.constant = self.view.bounds.size.width/4.0 - self.gridButton.bounds.size.width/2.0;
    self.flashButtonTrailConstraint.constant = self.view.bounds.size.width/4.0 - self.flashButton.bounds.size.width/2.0;
}

- (void)setupCaptureSession
{
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    
    // Setup the preview view
    [[self previewView] setSession:session];
    [((AVCaptureVideoPreviewLayer *)[[self previewView] layer]) setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    // Setup camera button status
    self.flashMode = AVCaptureFlashModeOff;
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];

    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(self.sessionQueue, ^{
        [self setBackgroundRecordingId:UIBackgroundTaskInvalid];
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [CamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        if ([self.session canAddInput:videoDeviceInput]) {
            [self.session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            [CamViewController setFlashMode:self.flashMode forDevice:videoDevice];
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
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([self.session canAddOutput:stillImageOutput]) {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
            [self.session addOutput:stillImageOutput];
            [self setStillImageOutput:stillImageOutput];
        }

        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        movieFileOutput.maxRecordedDuration = CMTimeMake(10, 1);
        if ([self.session canAddOutput:movieFileOutput]) {
            [self.session addOutput:movieFileOutput];
            [self setMovieFileOutput:movieFileOutput];
        }
    });
}

- (void)setupCamScrollView
{
    self.camScrollView.delegate = self;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecordLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0;
    [self.camScrollView.recordCaptureButton addGestureRecognizer:longPressGestureRecognizer];
}

#pragma mark Logic
- (void)handleRecordLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self startRecording];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStatePossible) {

    } else {
        [self stopRecording];
    }
}

- (void)startRecording
{
    [self.camScrollView.recordCaptureButton setHighlighted:YES];
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
    [self.progressView stopAnimation];
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording]) {
            [self setLockInterfaceRotation:YES];
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                [self setBackgroundRecordingId:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
            }
            [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
            [CamViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
            // Start recording to a temporary file.
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
    });
}

- (void)stopRecording
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        [self.progressView startAnimation];
    });
    
    dispatch_async([self sessionQueue], ^{
        if ([[self movieFileOutput] isRecording]) {
            [[self movieFileOutput] stopRecording];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.camScrollView.recordCaptureButton setHighlighted:NO];
        });
    });
}

#pragma mark Actions
- (IBAction)didCloseBarButtonItemClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didFlashButtonClicked:(id)sender
{
    // Disable all buttons
    self.flashButton.enabled = NO;
    self.flipButton.enabled = NO;
    self.gridButton.enabled = NO;

    [self.flashButton setSelected:!self.flashButton.selected];
    self.flashMode = self.flashButton.selected ? AVCaptureFlashModeAuto : AVCaptureFlashModeOff;
    
    
    
    dispatch_async([self sessionQueue], ^{
        [[self session] beginConfiguration];
        AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
        [CamViewController setFlashMode:self.flashMode forDevice:currentVideoDevice];
        [[self session] commitConfiguration];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Enable all buttons
            self.flashButton.enabled = YES;
            self.flipButton.enabled = YES;
            self.gridButton.enabled = YES;
        });
    });
}

- (IBAction)didGridButtonClicked:(id)sender
{
}

- (IBAction)didFlipButtonClicked:(id)sender
{
    // Disable all buttons
    self.flashButton.enabled = NO;
    self.flipButton.enabled = NO;
    self.gridButton.enabled = NO;
    
    [self closeCurtainWithCompletionHandler:^{
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
            
            AVCaptureDevice *videoDevice = [CamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
            AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
            
            [[self session] beginConfiguration];
            
            [[self session] removeInput:[self videoDeviceInput]];
            if ([[self session] canAddInput:videoDeviceInput]) {
                [CamViewController setFlashMode:self.flashMode forDevice:videoDevice];
                [[self session] addInput:videoDeviceInput];
                [self setVideoDeviceInput:videoDeviceInput];
            } else {
                [[self session] addInput:[self videoDeviceInput]];
            }
            
            [[self session] commitConfiguration];
            [self openCurtainWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Enable all buttons
                    self.flashButton.enabled = YES;
                    self.flipButton.enabled = YES;
                    self.gridButton.enabled = YES;
                });
            }];
        });
    }];
    
}

#pragma CamScrollBottom Action
- (void)didPicGalleryButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)didVideoGalleryButtonClicked:(id)sender
{
}

- (void)didStillCaptureButtonClicked:(id)sender
{
    [self closeCurtainWithCompletionHandler:^{
        dispatch_async([self sessionQueue], ^{
            [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
            [CamViewController setFlashMode:self.flashMode forDevice:[[self videoDeviceInput] device]];
            [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if (imageDataSampleBuffer) {
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:CamFilterViewControllerSegueIdentifier sender:image];
                    });
                }
            }];
        });
    }];
}

- (void)didRecordCaptureButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)didRecordCaptureButtonReleased:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer] captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

#pragma mark File Output Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error) {
		NSLog(@"%@", error);
    }

    [self closeCurtainWithCompletionHandler:^{
        [self setLockInterfaceRotation:NO];
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
                [self performSegueWithIdentifier:CamFilterViewControllerSegueIdentifier sender:nil];
            });
        }];
    }];
}

#pragma mark Device Configuration
- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        } else {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"AVCam!" message:@"AVCam doesn't have permission to use Camera, please change privacy settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
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

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
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

#pragma mark UI
- (void)closeCurtainWithCompletionHandler:(void (^)(void))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.curtainVerticalConstraint.constant = 0;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completionHandler) {
                completionHandler();
            }
        }];
    });
}

- (void)openCurtainWithCompletionHandler:(void (^)(void))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = (self.toolContainer.frame.origin.y+self.toolContainer.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            self.curtainVerticalConstraint.constant = height;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completionHandler) {
                completionHandler();
            }
        }];
    });
}

- (void)updateProgressView
{
    if (self.movieFileOutput.isRecording) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double recordedDuration = self.movieFileOutput.recordedDuration.value*1.0/self.movieFileOutput.recordedDuration.timescale;
            double maxDuration = self.movieFileOutput.maxRecordedDuration.value*1.0/self.movieFileOutput.maxRecordedDuration.timescale;
            self.progressView.progress = recordedDuration/maxDuration;
        });
    }
}

#pragma mark CamScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat c = self.camScrollView.stillCaptureButton.frame.origin.x;
    CGFloat factor = 0;
    if (self.lastPageIndex == 0) {
        factor = (self.camScrollView.contentOffset.x - 0)/c;
        factor = MAX(MIN(factor, 1.0), 0);
        factor = 1.0 - factor;
        self.camScrollView.stillCaptureButton.alpha = 0.1 + factor*0.9;
        self.camScrollView.recordCaptureButton.alpha = 0.1 + (1-factor)*0.9;
    } else {
        factor = 1 - (c - self.camScrollView.contentOffset.x)/c;
        factor = MAX(MIN(factor, 1.0), 0);
        self.camScrollView.recordCaptureButton.alpha = 0.1 + factor*0.9;
        self.camScrollView.stillCaptureButton.alpha = 0.1 + (1-factor)* 0.9;
    }
    
    CGFloat h = factor * (self.toolContainer.frame.origin.y + self.toolContainer.bounds.size.height);
    self.curtainVerticalConstraint.constant = h;
    
    [self.progressView stopAnimation];
    CGFloat f = 1 - (c - self.camScrollView.contentOffset.x)/c;
    self.progressView.alpha = MAX(MIN(f, 1.0), 0);;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSInteger pageIndex = [self.camScrollView pageOfContentOffset:scrollView.contentOffset];
        [self didScrollEndAtPageIndex:pageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = [self.camScrollView pageOfContentOffset:scrollView.contentOffset];
    [self didScrollEndAtPageIndex:pageIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger pageIndex = [self.camScrollView pageOfContentOffset:scrollView.contentOffset];
    [self didScrollEndAtPageIndex:pageIndex];
}

- (void)didScrollEndAtPageIndex:(NSInteger)pageIndex
{
    self.lastPageIndex = pageIndex;
    if (pageIndex == 0) {
        [self.camScrollView.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_media_video"] forState:UIControlStateNormal];
    } else {
        [self.camScrollView.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_media_photo"] forState:UIControlStateNormal];
    }
    [self openCurtainWithCompletionHandler:^{
        if (self.lastPageIndex == 1 && !self.recordingTimer) {
            [self.progressView startAnimation];
        }
    }];
}



@end
