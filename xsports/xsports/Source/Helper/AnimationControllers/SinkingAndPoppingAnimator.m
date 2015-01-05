//
//  SinkingAndPoppingAnimator.m
//  xsports
//
//  Created by Shengzhe Chen on 1/4/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "SinkingAndPoppingAnimator.h"

@interface SinkingAndPoppingAnimator ()
@property (assign, nonatomic) CGFloat scalor;
@end

@implementation SinkingAndPoppingAnimator

- (id)init
{
    if (self = [super init]) {
        self.scalor = 0.9;
        self.duration = 0.4f;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    UIView *containerView = [transitionContext containerView];
    
    if (!self.reverse) {
        [self sinkingViewStartingState:fromView containerFrame:containerView.bounds];
        [self poppingViewStartingState:toView containerFrame:containerView.bounds];
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:self.duration animations:^{
            [self sinkingViewEndingState:fromView containerFrame:containerView.bounds];
        }];

        [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self poppingViewEndingState:toView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self sinkingViewStartingState:fromView containerFrame:containerView.bounds];
                [self poppingViewStartingState:toView containerFrame:containerView.bounds];
            } else {
                [self sinkingViewEndingState:fromView containerFrame:containerView.bounds];
                [self poppingViewEndingState:toView containerFrame:containerView.bounds];
                fromView.alpha = 1.0;
            }
            [transitionContext completeTransition:finished];
        }];
    } else {
        [self sinkingViewEndingState:toView containerFrame:containerView.bounds];
        [self poppingViewEndingState:fromView containerFrame:containerView.bounds];
        [containerView insertSubview:toView belowSubview:fromView];
        [UIView animateWithDuration:self.duration * 0.75 animations:^{
            [self poppingViewStartingState:fromView containerFrame:containerView.bounds];
        }];
        
        [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self sinkingViewStartingState:toView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self sinkingViewStartingState:toView containerFrame:containerView.bounds];
                [self poppingViewStartingState:fromView containerFrame:containerView.bounds];
            } else {
                [self sinkingViewStartingState:toView containerFrame:containerView.bounds];
                [self poppingViewStartingState:fromView containerFrame:containerView.bounds];
            }
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark Private
- (void)sinkingViewStartingState:(UIView *)sinkingView containerFrame:(CGRect)containerFrame
{
    sinkingView.alpha = 1.0;
    sinkingView.layer.transform = CATransform3DIdentity;
    sinkingView.layer.position = CGPointMake(containerFrame.size.width/2.0, containerFrame.size.height/2.0);
    sinkingView.frame = containerFrame;
}

- (void)sinkingViewEndingState:(UIView *)sinkingView containerFrame:(CGRect)containerFrame
{
    sinkingView.alpha = 0.5;
    CGFloat dx = (containerFrame.size.width - containerFrame.size.width * self.scalor)/2.0;
    CGFloat dy = (containerFrame.size.height - containerFrame.size.height * self.scalor)/2.0;
    CGRect frame = CGRectInset(containerFrame, dx, dy);
    
    sinkingView.layer.transform = CATransform3DMakeScale(self.scalor, self.scalor, 1);
    sinkingView.frame = frame;
    sinkingView.layer.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}

- (void)poppingViewStartingState:(UIView *)poppingView containerFrame:(CGRect)containerFrame
{
    poppingView.frame = CGRectMake(containerFrame.origin.x, containerFrame.origin.y + containerFrame.size.height, containerFrame.size.width, containerFrame.size.height);
}

- (void)poppingViewEndingState:(UIView *)poppingView containerFrame:(CGRect)containerFrame
{
    poppingView.frame = containerFrame;
}

@end
