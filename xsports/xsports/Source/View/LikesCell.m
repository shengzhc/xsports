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
}

- (void)setupImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.image = [UIImage imageNamed:@"ico_myself"];
}

- (void)setupLabels
{
    self.accountLabel.font = [UIFont regularFont];
    self.accountLabel.textColor = [UIColor darkFujiColor];
    self.nameLabel.font = [UIFont regularFontWithSize:12];
    self.nameLabel.textColor = [UIColor semiWaveColor];
}

- (void)setLiker:(User *)liker
{
    _liker = liker;
    self.accountLabel.text = liker.userName;
    self.nameLabel.text = liker.fullName;
}

@end
