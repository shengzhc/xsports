//
//  FadingInOutAnimiator.m
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FadingInOutAnimiator.h"

@interface FadingInOutPresentingAnimator : NSObject < UIViewControllerAnimatedTransitioning >
@end

@implementation FadingInOutPresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.75;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGRect frame = containerView.bounds;
    toViewController.view.alpha = 0.0;
    toViewController.view.frame = frame;
    [containerView addSubview:toViewController.view];
    CGFloat duration = [self transitionDuration:transitionContext] * 0.8;
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        fromViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        fromViewController.view.alpha = 1.0;
    }];
}

@end

@implementation FadingInOutTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    FadingInOutPresentingAnimator *animaotr = [[FadingInOutPresentingAnimator alloc] init];
    return animaotr;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    FadingInOutPresentingAnimator *animator = [[FadingInOutPresentingAnimator alloc] init];
    return animator;
}

@end
