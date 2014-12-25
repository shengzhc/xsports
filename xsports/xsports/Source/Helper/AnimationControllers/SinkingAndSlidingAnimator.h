//
//  SinkingAndSlidingAnimator.h
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"

@interface SinkingAndSlidingAnimator : NSObject <UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>
@property (assign, nonatomic) CGFloat anchorRightRevealingAmount;
@end
