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
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (assign, nonatomic) BOOL wasAnimatingProgress;
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
        [self.progressView stopAnimation];
        _wasAnimatingProgress = NO;
    } else {
        self.nextButton.alpha = 1.0;
        self.progressView.alpha = 1.0;
        self.gridButton.alpha = 0.0;
        self.flashButton.alpha = 0.0;
        [self.progressView startAnimation];
        _wasAnimatingProgress = YES;
    }
}

- (void)enableButtons:(BOOL)enable
{
    self.gridButton.enabled = enable;
    self.flashButton.enabled = enable;
    self.rotateButton.enabled = enable;
    self.nextButton.enabled = enable;
    if (enable && _wasAnimatingProgress) {
        [self.progressView startAnimation];
    } else {
        [self.progressView stopAnimation];
    }
}

- (IBAction)didCloseButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(camCaptureOverlayViewController:didCloseButtonClicked:)]) {
        [self.delegate camCaptureOverlayViewController:self didCloseButtonClicked:sender];
    }
}

- (IBAction)didNextButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(camCaptureOverlayViewController:didNextButtonClicked:)]) {
        [self.delegate camCaptureOverlayViewController:self didNextButtonClicked:sender];
    }
}

- (IBAction)didGridButtonClicked:(id)sender
{
    self.isGridEnabled = !self.isGridEnabled;
    if ([self.delegate respondsToSelector:@selector(camCaptureOverlayViewController:didGridButtonClicked:)]) {
        [self.delegate camCaptureOverlayViewController:self didGridButtonClicked:sender];
    }
}

- (IBAction)didRotateButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(camCaptureOverlayViewController:didRotateButtonClicked:)]) {
        [self.delegate camCaptureOverlayViewController:self didRotateButtonClicked:sender];
    }
}

- (IBAction)didFlashButtonClicked:(id)sender
{
    self.flashMode = (self.flashMode == AVCaptureFlashModeOff ? AVCaptureFlashModeOn : (self.flashMode == AVCaptureFlashModeOn ? AVCaptureFlashModeAuto : AVCaptureFlashModeOff));
    if ([self.delegate respondsToSelector:@selector(camCaptureOverlayViewController:didFlashButtonClicked:)]) {
        [self.delegate camCaptureOverlayViewController:self didFlashButtonClicked:sender];
    }
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
