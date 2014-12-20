//
//  LoadingAnimator.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LoadingAnimator.h"

@interface LoadingPresentingAnimator : NSObject < UIViewControllerAnimatedTransitioning >
@property (assign, nonatomic) UIEdgeInsets contentInset;
@end

@implementation LoadingPresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGRect frame = UIEdgeInsetsInsetRect(containerView.bounds, self.contentInset);
    toViewController.view.layer.cornerRadius = 5.0;
    toViewController.view.layer.masksToBounds = YES;
    toViewController.view.alpha = 0.0;
    toViewController.view.frame = frame;
    toViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
 
    UIView *dimmingBackground = [[UIView alloc] initWithFrame:containerView.bounds];
    dimmingBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    dimmingBackground.alpha = 0.0;
    
    [containerView addSubview:dimmingBackground];
    [containerView addSubview:toViewController.view];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration/2.0 animations:^{
        toViewController.view.alpha = 1.0;
        dimmingBackground.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0/0.5 options:UIViewAnimationOptionCurveLinear animations:^
     {
         toViewController.view.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {
         [transitionContext completeTransition:YES];
     }];
}

@end

@interface LoadingDismissingAnimator : NSObject < UIViewControllerAnimatedTransitioning >
@end

@implementation LoadingDismissingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration*2.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:-12.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         fromViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
     } completion:nil];
    
    
    [UIView animateWithDuration:3.0*duration/4.0 delay:duration/4.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         fromViewController.view.alpha = 0.0;
     } completion:^(BOOL finished) {
         [fromViewController.view removeFromSuperview];
         [transitionContext completeTransition:YES];
     }];
}

@end

@implementation LoadingTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    LoadingPresentingAnimator *animator = [[LoadingPresentingAnimator alloc] init];
    animator.contentInset = UIEdgeInsetsZero;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    LoadingDismissingAnimator *animator = [[LoadingDismissingAnimator alloc] init];
    return animator;
}

@end



