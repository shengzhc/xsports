//
//  CamCaptureOverlayViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureOverlayViewController.h"

@interface CamCaptureOverlayViewController ()

@end

@implementation CamCaptureOverlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupButtons];
}

- (void)setupButtons
{
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont chnRegularFont];
}

- (IBAction)didCloseButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didNextButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)didGridButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)didRotateButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)didFlashButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)updateProgressView
{
//    if (self.movieFileOutput.isRecording) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            double recordedDuration = self.movieFileOutput.recordedDuration.value*1.0/self.movieFileOutput.recordedDuration.timescale;
//            double maxDuration = self.movieFileOutput.maxRecordedDuration.value*1.0/self.movieFileOutput.maxRecordedDuration.timescale;
//            self.progressView.progress = recordedDuration/maxDuration;
//        });
//    }
}


@end
