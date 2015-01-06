//
//  MenuViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "FeedViewController.h"
#import "SettingViewController.h"
#import "UserProfileViewController.h"

typedef enum : NSInteger {
    kMenuItemExplore,
    kMenuItemChat,
    kMenuItemVideo,
    kMenuItemContact,
    kMenuItemSetting,
    kMenuItemLogin,
    kMenuItemProfile
} MenuItem;

@interface MenuViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, LoginViewControllerDelegate >

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (assign, nonatomic) MenuItem selectedRow;

@property (strong, nonatomic) LoginViewController *loginViewController;

@property (strong, nonatomic) UINavigationController *navFeedViewController;
@property (strong, nonatomic) FeedViewController *feedViewController;

@property (strong, nonatomic) UINavigationController *navSettingViewController;
@property (strong, nonatomic) SettingViewController *settingViewController;

@property (strong, nonatomic) UINavigationController *navMyselfViewController;
@property (strong, nonatomic) UserProfileViewController *myselfViewController;

- (void)select:(MenuItem)menuItem animated:(BOOL)animated;

@end
