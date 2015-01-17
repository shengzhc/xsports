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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.seperator.backgroundColor = [UIColor cLightGrayColor];
}

- (void)setupLabels
{
    self.nameLabel.font = [UIFont chnRegularFont];
    self.nameLabel.textColor = [UIColor cYellowColor];
    self.commentLabel.font = [UIFont chnRegularFontWithSize:12];
    self.commentLabel.textColor = [UIColor cLightGrayColor];
    self.timeLabel.font = [UIFont chnRegularFontWithSize:12];
    self.timeLabel.textColor = [UIColor cYellowColor];
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    self.nameLabel.text = comment.creator.userName;
    self.commentLabel.text = comment.text;
    self.timeLabel.text = [comment.createdTime dateOffset];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.creator.profilePicture] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
}

@end
