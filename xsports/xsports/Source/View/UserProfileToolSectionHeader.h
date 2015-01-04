//
//  UserProfileToolSectionHeader.h
//  xsports
//
//  Created by Shengzhe Chen on 1/3/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserProfileToolSectionHeader;
@protocol UserProfileToolSectionHeaderDelegate <NSObject>
@optional
- (void)userProfileToolSectionHeader:(UserProfileToolSectionHeader *)header didGridButtonClicked:(id)sender;
- (void)userProfileToolSectionHeader:(UserProfileToolSectionHeader *)header didListButtonClicked:(id)sender;
@end

@interface UserProfileToolSectionHeader : UIView
@property (weak, nonatomic) id < UserProfileToolSectionHeaderDelegate > delegate;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@end
