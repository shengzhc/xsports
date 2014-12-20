//
//  PageNavigationController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/19/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "PageNavigationController.h"
#import "CECardsAnimationController.h"

@interface PageNavigationController () <UINavigationControllerDelegate>
@property (strong, nonatomic) CECardsAnimationController *cardAnimator;
@end

@implementation PageNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        self.cardAnimator = [[CECardsAnimationController alloc] init];
        self.cardAnimator.duration = 0.3f;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.cardAnimator.reverse = (operation == UINavigationControllerOperationPop);
    return self.cardAnimator;
}


@end
