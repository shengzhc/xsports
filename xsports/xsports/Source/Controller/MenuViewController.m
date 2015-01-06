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
    [self setupViews];
    [self setupTableView];
}

#pragma mark Setup
- (void)setupViews
{
    self.view.backgroundColor = [UIColor cGrayColor];
}

- (void)setupLabel
{
    self.nameLabel.font = [UIFont chnRegularFont];
    self.nameLabel.textColor = [UIColor cYellowColor];
    self.nameLabel.text = @"Frank Rapacciuolo";
    self.locationLabel.font = [UIFont chnRegularFontWithSize:10];
    self.locationLabel.textColor = [UIColor cYellowColor];
    self.locationLabel.text = @"San Francisco";
}

- (void)setupImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.borderWidth = 1.0;
    self.profileImageView.layer.borderColor = [UIColor cYellowColor].CGColor;
}

- (void)setupTableView
{
    self.tableView.rowHeight = 44;
}

- (void)setupButton
{
    self.logoutButton.layer.cornerRadius = 4.0;
    self.logoutButton.titleLabel.font = [UIFont chnRegularFont];
    [self.logoutButton setTitle:GET_STRING(@"signout") forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundColor:[UIColor clearColor]];
    self.logoutButton.layer.borderWidth = 1.0;
    self.logoutButton.layer.borderColor = [UIColor cYellowColor].CGColor;
}

- (void)setupMenuItem
{
    self.selectedRow = -1;
    
    {
        self.loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:LoginViewControllerIdentifier];
        self.loginViewController.delegate = self;
    }
    
    {
        self.navFeedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NavFeedViewControllerIdentifier];
        self.feedViewController = (FeedViewController *)self.navFeedViewController.topViewController;
        self.navFeedViewController.view.layer.cornerRadius = 5.0;
        self.navFeedViewController.view.layer.masksToBounds = YES;
        [self.navFeedViewController clearBackground];
    }
    
    {
        self.navSettingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NavSettingViewControllerIdentifier];
        self.settingViewController = (SettingViewController *)self.navSettingViewController.topViewController;
        [self.navSettingViewController clearBackground];
    }
    
}

#pragma mark Action
- (void)select:(MenuItem)menuItem animated:(BOOL)animated
{
    if (menuItem != self.selectedRow) {
        self.selectedRow = menuItem;
        switch (self.selectedRow) {
            case kMenuItemLogin:
                self.slidingViewController.topViewController = self.loginViewController;
                break;
            case kMenuItemExplore:
                self.slidingViewController.topViewController = self.navFeedViewController;
                break;
            case kMenuItemChat:
                break;
            case kMenuItemContact:
                break;
            case kMenuItemVideo:
                break;
            case kMenuItemSetting:
                self.slidingViewController.topViewController = self.navSettingViewController;
                break;
            default:
                break;
        }
    }
    
    if ([self.tableView numberOfRowsInSection:0] > self.selectedRow) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)didSignoutButtonClicked:(id)sender
{
    self.loginViewController = nil;
    self.loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:LoginViewControllerIdentifier];
    self.loginViewController.delegate = self;
    [[self slidingViewController] resetTopViewAnimated:YES onComplete:^{
        [self select:kMenuItemLogin animated:YES];
    }];
}

#pragma mark LoginViewControllerDelegate
- (void)loginViewController:(LoginViewController *)viewController didSignIn:(id)sender
{
    [self select:kMenuItemExplore animated:YES];
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
        case kMenuItemExplore:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_explore_gray"];
            [cell.iconImageView setHighlightedImage:[UIImage imageNamed:@"ico_explore_yellow"]];
            cell.iconTextLabel.text = GET_STRING(@"menu_explore");
            cell.topSeperator.hidden = NO;
        }
            break;
        case kMenuItemChat:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_chat_gray"];
            [cell.iconImageView setHighlightedImage:[UIImage imageNamed:@"ico_chat_yellow"]];
            cell.iconTextLabel.text = GET_STRING(@"menu_chat");
            cell.topSeperator.hidden = YES;
        }
            break;
        case kMenuItemContact:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_contact_gray"];
            [cell.iconImageView setHighlightedImage:[UIImage imageNamed:@"ico_contact_yellow"]];
            cell.iconTextLabel.text = GET_STRING(@"menu_contact");
            cell.topSeperator.hidden = YES;
        }
            break;
        case kMenuItemVideo:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_video_gray"];
            [cell.iconImageView setHighlightedImage:[UIImage imageNamed:@"ico_video_yellow"]];
            cell.iconTextLabel.text = GET_STRING(@"menu_video");
            cell.topSeperator.hidden = YES;
        }
            break;
        case kMenuItemSetting:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"ico_setting_gray"];
            [cell.iconImageView setHighlightedImage:[UIImage imageNamed:@"ico_setting_yellow"]];
            cell.iconTextLabel.text = GET_STRING(@"menu_setting");
            cell.topSeperator.hidden = YES;
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
