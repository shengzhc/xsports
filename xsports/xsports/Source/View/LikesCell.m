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
}

- (void)setupLabels
{
    self.accountLabel.font = [UIFont regularFont];
    self.accountLabel.textColor = [UIColor darkFujiColor];
    self.nameLabel.font = [UIFont chnRegularFontWithSize:12];
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
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:liker.profilePicture] placeholderImage:[UIImage imageNamed:@"ico_myself"]];
}

- (IBAction)didFollowButtonClicked:(id)sender
{
    CGRect frame = self.followButton.frame;
    frame.size.width *= 1.2;
    [UIView animateWithDuration:0.5 animations:^{
        self.followButton.transform = CGAffineTransformScale(self.followButton.transform, 1.2, 1.0);
        self.followButton.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    }];
}
@end
