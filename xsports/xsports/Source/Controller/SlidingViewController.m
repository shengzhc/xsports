//
//  SlidingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SlidingViewController.h"
#import "LoginViewController.h"

@interface SlidingViewController () < LoginViewControllerDelegate >
@property (strong, nonatomic) SinkingAndSlidingAnimator *animator;
@property (strong, nonatomic) LoginViewController *loginViewController;
@end

@implementation SlidingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.animator = [[SinkingAndSlidingAnimator alloc] init];
    self.delegate = self.animator;
    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;

    self.menuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:MenuViewControllerIdentifier];
    self.underLeftViewController = self.menuViewController;
    
    if (/* DISABLES CODE */ (NO)) {
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
        _loginViewController.delegate = self;
    }
    return _loginViewController;
}

#pragma mark LoginViewControllerDelegate
- (void)loginViewController:(LoginViewController *)viewController didSignIn:(id)sender
{
    [self.menuViewController select:kMenuItemNew animated:YES];
}

@end
