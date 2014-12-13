//
//  SlidingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SlidingViewController.h"
#import "LoginViewController.h"

#import "MEZoomAnimationController.h"

@interface SlidingViewController ()
@property (strong, nonatomic) MEZoomAnimationController *zoomAnimator;
@property (strong, nonatomic) LoginViewController *loginViewController;
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
    
    if (YES) {
        self.topViewController = self.loginViewController;
    } else {
        [self.menuViewController select:kMenuItemNew animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightPebbleColor];
}

- (LoginViewController *)loginViewController
{
    if (_loginViewController == nil) {
        _loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:LoginViewControllerIdentifier];
    }
    return _loginViewController;
}

@end
