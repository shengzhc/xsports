//
//  UserInfoViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 1/4/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoViewController;
@protocol UserInfoViewControllerDelegate <NSObject>
@optional
@end

@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *editFollowButton;
@property (weak, nonatomic) IBOutlet UIButton *followingAmountButton;
@property (weak, nonatomic) IBOutlet UIButton *followerAmountButton;
@property (weak, nonatomic) IBOutlet UIButton *feedAmountButton;

@property (weak, nonatomic) IBOutlet UILabel *followingAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedLabel;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *toolSeperators;

@end
