//
//  LoginViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginViewController:(LoginViewController *)viewController didSignIn:(id)sender;
@end

@interface LoginViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) id <LoginViewControllerDelegate> delegate;

@end
