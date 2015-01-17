//
//  CamCaptureModeViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureModeViewController.h"

@interface CamCaptureModeViewController () < UIScrollViewDelegate >
@property (assign, nonatomic) NSInteger lastPageIndex;
@property (strong, nonatomic) NSTimer *recordingTimer;
@end

@implementation CamCaptureModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
}

- (void)setupScrollView
{
    self.scrollView.backgroundColor = [[UIColor cSuperDarkBlackColor] colorWithAlphaComponent:0.9];
    self.scrollView.delegate = self;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecordLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0;
    [self.scrollView.recordCaptureButton addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleRecordLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.scrollView.recordCaptureButton setHighlighted:YES];
        if ([self.parentViewController respondsToSelector:@selector(startRecording)]) {
            [self.parentViewController performSelector:@selector(startRecording) withObject:nil afterDelay:0];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStatePossible) {
        
    } else {
        [self.scrollView.recordCaptureButton setHighlighted:NO];
        if ([self.parentViewController respondsToSelector:@selector(stopRecording)]) {
            [self.parentViewController performSelector:@selector(stopRecording) withObject:nil afterDelay:0];
        }
    }
}

#pragma mark CamScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat c = self.scrollView.stillCaptureButton.frame.origin.x;
    CGFloat factor = 0;
    if (self.lastPageIndex == 0) {
        factor = (self.scrollView.contentOffset.x - 0)/c;
        factor = MAX(MIN(factor, 1.0), 0);
        factor = 1.0 - factor;
        self.scrollView.stillCaptureButton.alpha = 0.1 + factor*0.9;
        self.scrollView.recordCaptureButton.alpha = 0.1 + (1-factor)*0.9;
    } else {
        factor = 1 - (c - self.scrollView.contentOffset.x)/c;
        factor = MAX(MIN(factor, 1.0), 0);
        self.scrollView.recordCaptureButton.alpha = 0.1 + factor*0.9;
        self.scrollView.stillCaptureButton.alpha = 0.1 + (1-factor)* 0.9;
    }
    
    if ([self.delegate respondsToSelector:@selector(camCaptureModeViewController:didScrollWithPercentage:toPage:)]) {
        [self.delegate camCaptureModeViewController:self didScrollWithPercentage:factor toPage:self.lastPageIndex == 0 ? 1 : 0];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSInteger pageIndex = [self.scrollView pageOfContentOffset:scrollView.contentOffset];
        [self didScrollEndAtPageIndex:pageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = [self.scrollView pageOfContentOffset:scrollView.contentOffset];
    [self didScrollEndAtPageIndex:pageIndex];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger pageIndex = [self.scrollView pageOfContentOffset:scrollView.contentOffset];
    [self didScrollEndAtPageIndex:pageIndex];

}

- (void)didScrollEndAtPageIndex:(NSInteger)pageIndex
{
    self.lastPageIndex = pageIndex;
    if (pageIndex == 0) {
        [self.scrollView.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_video"] forState:UIControlStateNormal];
    } else {
        [self.scrollView.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_camera_gray"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(camCaptureModeViewController:didEndDisplayingPageAtIndex:)]) {
        [self.delegate camCaptureModeViewController:self didEndDisplayingPageAtIndex:pageIndex];
    }
}


@end
