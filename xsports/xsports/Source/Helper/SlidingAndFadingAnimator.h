//
//  SlidingAndFadingAnimator.h
//  xsports
//
//  Created by Shengzhe Chen on 12/17/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlidingAndFadingAnimator : NSObject < UIViewControllerAnimatedTransitioning >
@end

@interface SlidingAndFadingTransitionContext : NSObject < UIViewControllerContextTransitioning >
@property (assign, nonatomic) BOOL goingRight;
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight;
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);
@end