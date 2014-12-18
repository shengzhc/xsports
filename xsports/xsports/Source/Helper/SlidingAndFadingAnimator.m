//
//  SlidingAndFadingAnimator.m
//  xsports
//
//  Created by Shengzhe Chen on 12/17/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SlidingAndFadingAnimator.h"


@implementation SlidingAndFadingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    CGFloat offset = container.bounds.size.width/2.0;
    if ([transitionContext isKindOfClass:[SlidingAndFadingTransitionContext class]]) {
        offset = ((SlidingAndFadingTransitionContext *)transitionContext).goingRight ? -offset: offset;
    }
    toViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, offset, 0);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration*0.5 animations:^{ toViewController.view.alpha = 1.0; fromViewController.view.alpha = 0.0; }];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        fromViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -offset, 0);
        toViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.alpha = 1.0;
        [transitionContext completeTransition:finished];
    }];
}

@end

@interface SlidingAndFadingTransitionContext ()
@property (weak, nonatomic) UIViewController *fromViewController;
@property (weak, nonatomic) UIViewController *toViewController;
@end

@implementation SlidingAndFadingTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight
{
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    if ((self = [super init])) {
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
        self.goingRight = goingRight;
    }
    
    return self;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}
- (BOOL)isAnimated { return YES; }
- (BOOL)isInteractive { return NO; }
- (BOOL)transitionWasCancelled { return NO; }
- (UIModalPresentationStyle)presentationStyle { return UIModalPresentationCustom; }
- (UIView *)containerView { return self.fromViewController.view.superview; }

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromViewController;
    } else {
        return self.toViewController;
    }
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
    return self.containerView.bounds;
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    return self.containerView.bounds;
}

- (void)completeTransition:(BOOL)didComplete
{
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

@end

