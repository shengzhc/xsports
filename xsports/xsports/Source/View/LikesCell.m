//
//  LikesCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/19/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LikesCell.h"

@implementation LikesCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupImageView];
    [self setupLabels];
    [self setupButtons];
}

- (void)setupImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.seperator.backgroundColor = [UIColor cLightGrayColor];
}

- (void)setupLabels
{
    self.accountLabel.font = [UIFont chnRegularFont];
    self.accountLabel.textColor = [UIColor cYellowColor];
    self.nameLabel.font = [UIFont chnRegularFontWithSize:12];
    self.nameLabel.textColor = [UIColor cLightGrayColor];
}

- (void)setupButtons
{
    self.followButton.layer.cornerRadius = 5.0;
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.borderColor = [UIColor cYellowColor].CGColor;
    self.followButton.layer.borderWidth = 1;

    [self.followButton setImage:[UIImage imageNamed:@"ico_add_yellow"] forState:UIControlStateNormal];
    [self.followButton setTitle:GET_STRING(@"follow") forState:UIControlStateNormal];

    [self.followButton setImage:[UIImage imageNamed:@"ico_add_coral"] forState:UIControlStateSelected];
    [self.followButton setTitle:GET_STRING(@"cancel_follow") forState:UIControlStateSelected];

    [self.followButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    [self.followButton setTitleColor:[UIColor cCoralColor] forState:UIControlStateSelected];
    self.followButton.titleLabel.font = [UIFont chnRegularFontWithSize:10];
    
    [self.followButton sizeToFit];
    self.followButton.layer.cornerRadius = self.followButton.bounds.size.height/2.0;
    self.followButton.layer.masksToBounds = YES;
}

- (void)setLiker:(User *)liker
{
    _liker = liker;
    self.accountLabel.text = liker.userName;
    self.nameLabel.text = liker.fullName;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:liker.profilePicture] placeholderImage:[UIImage imageNamed:@"ico_myself"]];
}

- (IBAction)didFollowButtonClicked:(id)sender
{
    [self.followButton setSelected:!self.followButton.selected];
    self.followButton.layer.borderColor = self.followButton.selected ? [UIColor lightCoralColor].CGColor : [UIColor cYellowColor].CGColor;
}

@end
