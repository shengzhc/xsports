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
    UIView *assetsBottom = assetsPickerViewController.bottomContainer;
    UIView *assetsContent = assetsPickerViewController.contentContainer;
    UIView *captureOverlay = camCaptureViewController.overlayContainer;
    UIView *captureBottom = camCaptureViewController.bottomContainer;
    UIView *captureContent = camCaptureViewController.previewView;
    UIView *captureCurtain = camCaptureViewController.curtainContainer;
    
    captureCurtain.alpha = 0;
    captureContent.alpha = 0;
    assetsContent.alpha = 0;
    
    assetsPickerViewController.view.frame = [transitionContext finalFrameForViewController:assetsPickerViewController];
    assetsOverlay.frame = CGRectMake(captureOverlay.bounds.size.width, 0, captureOverlay.bounds.size.width, captureOverlay.bounds.size.height);
    [containerView insertSubview:assetsPickerViewController.view belowSubview:camCaptureViewController.view];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        captureOverlay.frame = CGRectMake(-captureOverlay.bounds.size.width, 0, captureOverlay.bounds.size.width, captureOverlay.bounds.size.height);
        captureBottom.frame = CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, captureBottom.frame.size.height);
        assetsOverlay.frame = CGRectMake(0, 0, containerView.bounds.size.width, assetsOverlay.frame.size.height);
    } completion:^(BOOL finished) {
        assetsOverlay.frame = CGRectMake(0, 0, containerView.bounds.size.width, assetsOverlay.frame.size.height);
        captureOverlay.frame = assetsOverlay.frame;
        captureBottom.frame = assetsBottom.frame;
        assetsPickerViewController.view.frame = [transitionContext finalFrameForViewController:assetsPickerViewController];
        captureCurtain.alpha = 1;
        captureContent.alpha = 1;
        assetsContent.alpha = 1;
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
    UIView *assetsContent = assetsPickerViewController.contentContainer;
    UIView *captureOverlay = camCaptureViewController.overlayContainer;
    UIView *captureBottom = camCaptureViewController.bottomContainer;
    UIView *captureContent = camCaptureViewController.previewView;
    UIView *captureCurtain = camCaptureViewController.curtainContainer;
    
    captureCurtain.alpha = 0;
    captureContent.alpha = 0;
    
    camCaptureViewController.view.frame = [transitionContext finalFrameForViewController:camCaptureViewController];
    captureOverlay.frame = CGRectMake(-assetsOverlay.bounds.size.width, 0, assetsOverlay.bounds.size.width, assetsOverlay.bounds.size.height);
    captureBottom.frame = CGRectMake(0, containerView.bounds.size.height, captureBottom.bounds.size.width, captureBottom.bounds.size.height);
    [containerView addSubview:camCaptureViewController.view];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        captureOverlay.frame = CGRectMake(0, 0, captureOverlay.bounds.size.width, captureOverlay.bounds.size.height);
        captureBottom.frame = assetsBottom.frame;
        assetsOverlay.frame = CGRectMake(assetsOverlay.bounds.size.width, 0, assetsOverlay.bounds.size.width, assetsOverlay.bounds.size.height);
    } completion:^(BOOL finished) {
        captureOverlay.frame = CGRectMake(0, 0, captureOverlay.bounds.size.width, captureOverlay.bounds.size.height);
        captureBottom.frame = assetsBottom.frame;
        camCaptureViewController.view.frame = [transitionContext finalFrameForViewController:camCaptureViewController];
        captureCurtain.alpha = 1;
        captureContent.alpha = 1;
        [transitionContext completeTransition:YES];
    }];
}


@end
