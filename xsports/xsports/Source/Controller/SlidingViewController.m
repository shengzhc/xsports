//
//  SlidingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SlidingViewController.h"
#import "MEZoomAnimationController.h"

@interface SlidingViewController ()
@property (strong, nonatomic) SinkingAndSlidingAnimator *animator;
@property (strong, nonatomic) MEZoomAnimationController *zoomAnimator;
@end

@implementation SlidingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.anchorRightRevealAmount = [UIScreen width] * 0.3;
    self.animator = [[SinkingAndSlidingAnimator alloc] init];
    self.delegate = self.animator;
    self.animator.anchorRightRevealingAmount = self.anchorRightRevealAmount;

    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping;
    self.menuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:MenuViewControllerIdentifier];
    self.underLeftViewController = self.menuViewController;
    
    if (/* DISABLES CODE */ (NO)) {
        [self.menuViewController select:kMenuItemLogin animated:NO];
    } else {
        [self.menuViewController select:kMenuItemNew animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightPebbleColor];
}

@end
