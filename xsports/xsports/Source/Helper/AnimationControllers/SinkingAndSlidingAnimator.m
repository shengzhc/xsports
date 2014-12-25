//
//  SinkingAndSlidingAnimator.m
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SinkingAndSlidingAnimator.h"

static CGFloat const MEZoomAnimationScaleFactor = 0.75;

@interface SinkingAndSlidingAnimator ()
@property (nonatomic, assign) ECSlidingViewControllerOperation operation;
- (CGRect)topViewAnchoredRightFrame:(ECSlidingViewController *)slidingViewController;
- (void)topViewStartingState:(UIView *)topView containerFrame:(CGRect)containerFrame;
- (void)topViewAnchorRightEndState:(UIView *)topView anchoredFrame:(CGRect)anchoredFrame;
- (void)underLeftViewStartingState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame;
- (void)underLeftViewEndState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame;
@end

@implementation SinkingAndSlidingAnimator

#pragma mark - ECSlidingViewControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController
                                   animationControllerForOperation:(ECSlidingViewControllerOperation)operation
                                                 topViewController:(UIViewController *)topViewController
{
    self.operation = operation;
    return self;
}

- (id<ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController
                        layoutControllerForTopViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition
{
    return self;
}

#pragma mark - ECSlidingViewControllerLayout
- (CGRect)slidingViewController:(ECSlidingViewController *)slidingViewController frameForViewController:(UIViewController *)viewController topViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition
{
    if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight && viewController == slidingViewController.topViewController) {
        return [self topViewAnchoredRightFrame:slidingViewController];
    } else {
        return CGRectInfinite;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    UIViewController *underLeftViewController  = [transitionContext viewControllerForKey:ECTransitionContextUnderLeftControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *topView = topViewController.view;
    topView.frame = containerView.bounds;

    if (self.operation == ECSlidingViewControllerOperationAnchorRight) {
        [containerView insertSubview:underLeftViewController.view aboveSubview:topView];
        [self topViewStartingState:topView containerFrame:containerView.bounds];
        [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewEndState:underLeftViewController.view containerFrame:containerView.bounds];
            [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext finalFrameForViewController:topViewController]];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                underLeftViewController.view.frame = [transitionContext finalFrameForViewController:underLeftViewController];
                underLeftViewController.view.alpha = 1;
                [self topViewStartingState:topView containerFrame:containerView.bounds];
            }
            
            [transitionContext completeTransition:finished];
        }];
    } else if (self.operation == ECSlidingViewControllerOperationResetFromRight) {
        [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
        [self underLeftViewEndState:underLeftViewController.view containerFrame:containerView.bounds];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
            [self topViewStartingState:topView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self underLeftViewEndState:underLeftViewController.view containerFrame:containerView.bounds];
                [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
            } else {
                underLeftViewController.view.alpha = 1;
                underLeftViewController.view.layer.transform = CATransform3DIdentity;
                [underLeftViewController.view removeFromSuperview];
            }
            
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - Private
- (CGRect)topViewAnchoredRightFrame:(ECSlidingViewController *)slidingViewController
{
    CGRect frame = slidingViewController.view.bounds;
    frame.size.width = frame.size.width * MEZoomAnimationScaleFactor;
    frame.size.height = frame.size.height * MEZoomAnimationScaleFactor;
    frame.origin.y = (slidingViewController.view.bounds.size.height - frame.size.height)/2.0;
    frame.origin.x = (slidingViewController.view.bounds.size.width - frame.size.width)/2.0;
    return frame;
}

- (void)topViewStartingState:(UIView *)topView containerFrame:(CGRect)containerFrame
{
    topView.layer.transform = CATransform3DIdentity;
    topView.layer.position  = CGPointMake(containerFrame.size.width / 2, containerFrame.size.height / 2);
}

- (void)topViewAnchorRightEndState:(UIView *)topView anchoredFrame:(CGRect)anchoredFrame
{
    topView.layer.transform = CATransform3DMakeScale(MEZoomAnimationScaleFactor, MEZoomAnimationScaleFactor, 1);
    topView.frame = anchoredFrame;
    topView.layer.position  = CGPointMake(CGRectGetMidX(anchoredFrame), CGRectGetMidY(anchoredFrame));
}

- (void)underLeftViewStartingState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame
{
    underLeftView.alpha = 0.0;
    underLeftView.frame = CGRectMake(containerFrame.origin.x - containerFrame.size.width, containerFrame.origin.y, containerFrame.size.width, containerFrame.size.height);
}

- (void)underLeftViewEndState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame
{
    underLeftView.alpha = 1.0;
    underLeftView.frame = containerFrame;
}

@end

