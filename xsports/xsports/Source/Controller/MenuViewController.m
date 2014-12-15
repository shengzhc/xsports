//
//  MenuViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuViewCell.h"

@implementation MenuViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupMenuItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupImageView];
    [self setupLabel];
    [self setupButton];
}

#pragma mark Setup
- (void)setupLabel
{
    self.nameLabel.font = [UIFont regularFontWithSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = @"Frank Rapacciuolo";
    self.locationLabel.font = [UIFont regularFont];
    self.locationLabel.textColor = [UIColor darkJadeColor];
    self.locationLabel.text = @"San Francisco";
}

- (void)setupImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.borderWidth = 2;
    self.profileImageView.layer.borderColor = [UIColor semiFujiColor].CGColor;
}

- (void)setupTableView
{
    self.tableView.rowHeight = 70;
}

- (void)setupButton
{
    self.logoutButton.layer.cornerRadius = 4.0;
    self.logoutButton.titleLabel.font = [UIFont regularFontWithSize:18];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundColor:[UIColor clearColor]];
    self.logoutButton.layer.borderWidth = 1.5;
    self.logoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setupMenuItem
{
    self.selectedRow = -1;
    
    {
        self.navFeedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NavFeedViewControllerIdentifier];
        self.feedViewController = (FeedViewController *)self.navFeedViewController.topViewController;
        [self.navFeedViewController clearBackground];
    }
    
    {
        self.navSettingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NavSettingViewControllerIdentifier];
        self.settingViewController = (SettingViewController *)self.navSettingViewController.topViewController;
        [self.navSettingViewController clearBackground];
    }
}

#pragma mark
- (void)select:(MenuItem)menuItem animated:(BOOL)animated
{
    if (menuItem != self.selectedRow) {
        self.selectedRow = menuItem;
        switch (self.selectedRow) {
            case kMenuItemNew:
                self.slidingViewController.topViewController = self.navFeedViewController;
                break;
            case kMenuItemChat:
                break;
            case kMenuItemContact:
                break;
            case kMenuItemFavorite:
                break;
            case kMenuItemSetting:
                self.slidingViewController.topViewController = self.navSettingViewController;
                break;
            default:
                break;
        }
    }

    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuViewCellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case kMenuItemNew:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_new"];
            cell.iconTextLabel.text = @"New Feeds";
        }
            break;
        case kMenuItemChat:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_chat"];
            cell.iconTextLabel.text = @"Chats";
        }
            break;
        case kMenuItemContact:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_contact"];
            cell.iconTextLabel.text = @"Contacts";
        }
            break;
        case kMenuItemFavorite:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_fav"];
            cell.iconTextLabel.text = @"Favorites";
        }
            break;
        case kMenuItemSetting:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_setting"];
            cell.iconTextLabel.text = @"Settings";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self select:indexPath.row animated:YES];
}

@end
