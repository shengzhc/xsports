//
//  MenuViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "SettingViewController.h"

typedef enum : NSInteger {
    kMenuItemNew,
    kMenuItemChat,
    kMenuItemFavorite,
    kMenuItemContact,
    kMenuItemSetting
} MenuItem;

@interface MenuViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (assign, nonatomic) MenuItem selectedRow;

@property (strong, nonatomic) UINavigationController *navFeedViewController;
@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) UINavigationController *navSettingViewController;
@property (strong, nonatomic) SettingViewController *settingViewController;

- (void)select:(MenuItem)menuItem animated:(BOOL)animated;

@end
