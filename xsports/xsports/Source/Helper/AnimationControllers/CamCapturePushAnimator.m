//
//  CamCapturePushAnimator.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "CamCapturePushAnimator.h"
#import "CamCaptureViewController.h"
#import "AssetsPickerViewController.h"

@implementation CamCapturePushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    AssetsPickerViewController *assetsPickerViewController = (AssetsPickerViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CamCaptureViewController *camCaptureViewController = (CamCaptureViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:assetsPickerViewController.view];
    assetsPickerViewController.view.frame = CGRectMake(containerView.bounds.size.width, 0, containerView.bounds.size.width, containerView.bounds.size.height);
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        camCaptureViewController.view.frame = CGRectMake(-containerView.bounds.size.width, 0, containerView.bounds.size.width, containerView.bounds.size.height);
        assetsPickerViewController.view.frame = [transitionContext finalFrameForViewController:assetsPickerViewController];
    } completion:^(BOOL finished) {
        assetsPickerViewController.view.frame = [transitionContext finalFrameForViewController:assetsPickerViewController];
        [transitionContext completeTransition:YES];
    }];
    
}

@end
