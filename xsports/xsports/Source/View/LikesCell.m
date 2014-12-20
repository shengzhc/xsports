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
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.layer.masksToBounds = YES;
    int rand = random()%4+1;
    NSString *name = [NSString stringWithFormat:@"img_profile_0%@", @(rand)];
    self.profileImageView.image = [UIImage imageNamed:name];
}

- (void)setupLabels
{
    self.accountLabel.font = [UIFont regularFont];
    self.accountLabel.textColor = [UIColor darkFujiColor];
    self.nameLabel.font = [UIFont regularFontWithSize:12];
    self.nameLabel.textColor = [UIColor semiWaveColor];
}

- (void)setupButtons
{
    [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.followButton.titleLabel.font = [UIFont regularFont];
    self.followButton.layer.cornerRadius = 5.0;
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.followButton.layer.borderWidth = 1.5;
}

- (void)setLiker:(User *)liker
{
    _liker = liker;
    self.accountLabel.text = liker.userName;
    self.nameLabel.text = liker.fullName;
}

- (IBAction)didFollowButtonClicked:(id)sender
{
}
@end
