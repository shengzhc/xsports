//
//  CommentsCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/20/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupImageView];
    [self setupLabels];
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
    self.nameLabel.font = [UIFont regularFont];
    self.nameLabel.textColor = [UIColor darkFujiColor];
    self.commentLabel.font = [UIFont regularFontWithSize:12];
    self.commentLabel.textColor = [UIColor semiWaveColor];
    self.timeLabel.font = [UIFont regularFontWithSize:12];
    self.timeLabel.textColor = [UIColor darkFujiColor];
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    self.nameLabel.text = comment.creator.userName;
    self.commentLabel.text = comment.text;
    self.timeLabel.text = [comment.createdTime dateOffset];
}

@end
