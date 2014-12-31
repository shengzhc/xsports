//
//  CamCaptureOverlayViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureOverlayViewController.h"

@interface CamCaptureOverlayViewController ()
@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@end

@implementation CamCaptureOverlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupButtons];
    [self setupViews];
}

- (void)setupViews
{
    self.progressView.backgroundColor = [UIColor blackColor];
    self.topBarView.backgroundColor = [[UIColor cSuperDarkBlackColor] colorWithAlphaComponent:0.9];
    self.toolBarView.backgroundColor = [[UIColor cSuperDarkBlackColor] colorWithAlphaComponent:0.9];
}

- (void)setupButtons
{
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont chnRegularFont];
}

- (void)transitionWithPercent:(CGFloat)percent toPageIndex:(NSUInteger)pageIndex
{
    self.nextButton.alpha = self.progressView.alpha = pageIndex == 0 ? percent : (1 - percent);
    self.gridButton.alpha = self.flashButton.alpha = 1 - self.nextButton.alpha;
    [self.progressView stopAnimation];
}

- (void)didEndTransitionToPageIndex:(NSUInteger)pageIndex
{
    if (pageIndex == 0) {
        self.nextButton.alpha = 0;
        self.progressView.alpha = 0;
        self.gridButton.alpha = 1;
        self.flashButton.alpha = 1;
    } else {
        self.nextButton.alpha = 1.0;
        self.progressView.alpha = 1.0;
        self.gridButton.alpha = 0.0;
        self.flashButton.alpha = 0.0;
        [self.progressView startAnimation];
    }
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
