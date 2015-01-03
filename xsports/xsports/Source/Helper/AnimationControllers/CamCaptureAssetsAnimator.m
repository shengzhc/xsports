//
//  CamCapturePushAnimator.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureAssetsAnimator.h"
#import "CamCaptureViewController.h"
#import "AssetsPickerViewController.h"

@implementation CamCaptureAssetsAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.operation == UINavigationControllerOperationPush) {
        [self pushAnimationWithTransitionContext:transitionContext];
    } else {
        [self popAnimationWithTransitionContext:transitionContext];
    }
}

- (void)pushAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    AssetsPickerViewController *assetsPickerViewController = (AssetsPickerViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CamCaptureViewController *camCaptureViewController = (CamCaptureViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *assetsOverlay = assetsPickerViewController.overlayContainer;
    UIView *captureOverlay = camCaptureViewController.overlayContainer;
    UIView *captureBottom = camCaptureViewController.bottomContainer;
    UIView *captureContent = camCaptureViewController.previewView;
    UIView *captureCurtain = camCaptureViewController.curtainContainer;

    CGRect leftOverlayFrame = CGRectMake(captureOverlay.frame.origin.x - captureOverlay.frame.size.width, captureOverlay.frame.origin.y, captureOverlay.frame.size.width, captureOverlay.frame.size.height);
    CGRect midOverlayFrame = captureOverlay.frame;
    CGRect rightOverlayFrame = CGRectOffset(midOverlayFrame, captureOverlay.frame.size.width, 0);
    CGRect upBottomFrame = captureBottom.frame;
    CGRect downBottomFrame = CGRectOffset(upBottomFrame, 0, upBottomFrame.size.height);
    
    captureCurtain.alpha = 0;
    captureContent.alpha = 0;
    
    assetsPickerViewController.view.frame = [transitionContext finalFrameForViewController:assetsPickerViewController];
    assetsOverlay.frame = rightOverlayFrame;
    [containerView insertSubview:assetsPickerViewController.view belowSubview:camCaptureViewController.view];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        captureOverlay.frame = leftOverlayFrame;
        captureBottom.frame = downBottomFrame;
        assetsOverlay.frame = midOverlayFrame;
    } completion:^(BOOL finished) {
        captureOverlay.frame = midOverlayFrame;
        captureBottom.frame = upBottomFrame;
        assetsOverlay.frame = midOverlayFrame;
        captureCurtain.alpha = 1;
        captureContent.alpha = 1;
        assetsPickerViewController.view.frame = [transitionContext finalFrameForViewController:assetsPickerViewController];
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    AssetsPickerViewController *assetsPickerViewController = (AssetsPickerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CamCaptureViewController *camCaptureViewController = (CamCaptureViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *assetsOverlay = assetsPickerViewController.overlayContainer;
    UIView *assetsBottom = assetsPickerViewController.bottomContainer;
    UIView *captureOverlay = camCaptureViewController.overlayContainer;
    UIView *captureBottom = camCaptureViewController.bottomContainer;
    UIView *captureContent = camCaptureViewController.previewView;
    UIView *captureCurtain = camCaptureViewController.curtainContainer;
    
    CGRect leftOverlayFrame = CGRectMake(assetsOverlay.frame.origin.x - assetsOverlay.frame.size.width, assetsOverlay.frame.origin.y, assetsOverlay.frame.size.width, assetsOverlay.frame.size.height);
    CGRect midOverlayFrame = assetsOverlay.frame;
    CGRect rightOverlayFrame = CGRectOffset(midOverlayFrame, assetsOverlay.frame.size.width, 0);
    CGRect upBottomFrame = assetsBottom.frame;
    CGRect downBottomFrame = CGRectOffset(upBottomFrame, 0, upBottomFrame.size.height);

    camCaptureViewController.view.frame = [transitionContext finalFrameForViewController:camCaptureViewController];
    [containerView addSubview:camCaptureViewController.view];
    captureOverlay.frame = leftOverlayFrame;
    captureBottom.frame = downBottomFrame;
    
    captureCurtain.alpha = 0;
    captureContent.alpha = 0;
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        captureOverlay.frame = midOverlayFrame;
        captureBottom.frame = upBottomFrame;
        assetsOverlay.frame = rightOverlayFrame;
    } completion:^(BOOL finished) {
        captureOverlay.frame = midOverlayFrame;
        captureBottom.frame = upBottomFrame;
        assetsOverlay.frame = midOverlayFrame;
        captureCurtain.alpha = 1;
        captureContent.alpha = 1;
        camCaptureViewController.view.frame = [transitionContext finalFrameForViewController:camCaptureViewController];
        [transitionContext completeTransition:YES];
    }];
}


@end
