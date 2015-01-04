//
//  UserProfileViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 1/3/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserInfoViewController.h"
#import "FeedFlowCollectionViewController.h"

#import "UserProfileToolSectionHeader.h"
#import "FeedViewPhotoCell.h"
#import "FeedViewVideoCell.h"
#import "FeedViewGridPhotoCell.h"
#import "FeedViewGridVideoCell.h"

@interface UserProfileViewController () < UICollectionViewDelegateFlowLayout >
@property (strong, nonatomic) UserInfoViewController *userInfoViewController;
@property (strong, nonatomic) FeedFlowCollectionViewController *flowCollectionViewController;
@property (strong, nonatomic) User *user;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self loadUser];
    [self loadFeed];
}

- (void)setUser:(User *)user
{
    _user = user;
    self.userInfoViewController.user = user;
}

- (void)setupViews
{
    [self.navigationController clearBackground];
    self.view.backgroundColor = [UIColor cGrayColor];
}

- (void)loadUser
{
    NSAssert(self.userId != nil, @"User Id should not be empty");
    [[InstagramServices sharedInstance] getUserInfoWithUserId:self.userId successBlock:^(NSError *error, id response) {
        self.user = response;
    } failBlock:^(NSError *error, id response) {
        self.user = nil;
    }];
}

- (void)loadFeed
{
    NSAssert(self.userId != nil, @"User Id should not be empty");
}

#pragma mark Action
- (IBAction)didBackBarButtonItemClicked:(id)sender
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers[0] == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didEditUserBarButtonClicked:(id)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UserProfileInfoViewControllerSegueIdentifier]) {
        self.userInfoViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:UserFeedFlowCollectionViewControllerSegueIdentifier]) {
        self.flowCollectionViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}
@end
