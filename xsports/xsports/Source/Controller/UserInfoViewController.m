//
//  UserInfoViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 1/4/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupButtons];
    [self setupViews];
    [self update];
}

- (void)setupButtons
{
    [self.followingAmountButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    [self.followingAmountButton setTitle:nil forState:UIControlStateNormal];
    
    [self.followerAmountButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    [self.followerAmountButton setTitle:nil forState:UIControlStateNormal];

    [self.feedAmountButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    [self.feedAmountButton setTitle:nil forState:UIControlStateNormal];
    
    [self.editFollowButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    self.editFollowButton.titleLabel.font = [UIFont chnRegularFontWithSize:12.0];
    [self.editFollowButton setTitle:nil forState:UIControlStateNormal];
    self.editFollowButton.layer.borderColor = [UIColor cYellowColor].CGColor;
    self.editFollowButton.layer.borderWidth = 1.0;
}

- (void)setupViews
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderColor = [UIColor cLightYellowColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0;
    
    self.nameLabel.font = [UIFont chnRegularFontWithSize:16.0];
    self.nameLabel.textColor = [UIColor cYellowColor];
    
    self.descriptionLabel.font = [UIFont chnRegularFontWithSize:8.0];
    self.descriptionLabel.textColor = [UIColor cYellowColor];
    
    self.followingAmountLabel.font = [UIFont chnRegularFont];
    self.followingAmountLabel.textColor = [UIColor cYellowColor];
    self.followingLabel.font = [UIFont chnRegularFontWithSize:8.0];
    self.followingLabel.textColor = [UIColor cYellowColor];
    self.followingLabel.text = GET_STRING(@"user_follow");

    self.followerAmountLabel.font = [UIFont chnRegularFontWithSize:14.0];
    self.followerAmountLabel.textColor = [UIColor cYellowColor];
    self.followerLabel.font = [UIFont chnRegularFontWithSize:8.0];
    self.followerLabel.textColor = [UIColor cYellowColor];
    self.followerLabel.text = GET_STRING(@"user_follower");

    self.feedAmountLabel.font = [UIFont chnRegularFontWithSize:14.0];
    self.feedAmountLabel.textColor = [UIColor cYellowColor];
    self.feedLabel.font = [UIFont chnRegularFontWithSize:8.0];
    self.feedLabel.textColor = [UIColor cYellowColor];
    self.feedLabel.text = GET_STRING(@"user_post");
    
    for (UIView *seperator in self.toolSeperators) {
        seperator.backgroundColor = [UIColor cYellowColor];
    }
}

- (void)setUser:(User *)user
{
    _user = user;
    [self update];
}

- (void)update
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.user.profilePicture] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    self.profileImageView.image = image;
                    UIImage *blur = [image gaussianBlurImage];
                    self.backgroundImageView.image = blur;
                }
            });
        }];
        self.nameLabel.text = self.user.fullName;
        self.descriptionLabel.text = self.user.bio;
        self.followingAmountLabel.text = self.user.totalFollows;
        self.followerAmountLabel.text = self.user.totalFollowers;
        self.feedAmountLabel.text = self.user.totalMedias;
        if (self.user) {
            if ([self.user isCurrentUser]) {
                [self.editFollowButton setTitle:GET_STRING(@"user_edit") forState:UIControlStateNormal];
            } else {
                [self.editFollowButton setTitle:GET_STRING(@"user_follow") forState:UIControlStateNormal];
            }
        }
    });
}

#pragma mark Action
- (IBAction)didEditOrFollowButtonClicked:(id)sender
{
}

- (IBAction)didFollowingAmountButtonClicked:(id)sender
{
}
- (IBAction)didFollowerAmountButtonClicked:(id)sender
{
}

- (IBAction)didFeedAmountButtonClicked:(id)sender
{
}

@end
