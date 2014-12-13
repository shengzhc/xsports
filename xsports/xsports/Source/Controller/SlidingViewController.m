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
@property (strong, nonatomic) MEZoomAnimationController *zoomAnimator;
@end

@implementation SlidingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.zoomAnimator = [[MEZoomAnimationController alloc] init];
    self.delegate = self.zoomAnimator;
    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;

    self.menuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:MenuViewControllerIdentifier];
    self.underLeftViewController = self.menuViewController;
    [self.menuViewController select:kMenuItemNew animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightPebbleColor];
}

@end
