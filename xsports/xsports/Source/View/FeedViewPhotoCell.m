//
//  FeedViewPhotoCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewPhotoCell.h"

@implementation FeedViewPhotoCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont chnRegularFont];
    self.nameLabel.textColor = [UIColor cYellowColor];
    self.timeLabel.font = [UIFont chnRegularFontWithSize:12.0];
    self.timeLabel.textColor = [UIColor cYellowColor];
    self.topSeperator.backgroundColor = [UIColor clearColor];
    
    self.likeAmountButton.titleLabel.font = [UIFont chnRegularFontWithSize:12.0];
    [self.likeAmountButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateNormal];
    self.captionLabel.font = [UIFont chnRegularFontWithSize:12.0];
    self.captionLabel.textColor = [UIColor cLightGrayColor];
    
    self.shareButton.layer.cornerRadius = 2.0;
    [self.shareButton setBackgroundColor:[UIColor cYellowColor]];

    self.commentButton.layer.cornerRadius = 2.0;
    [self.commentButton setBackgroundColor:[UIColor cYellowColor]];
    self.commentButton.titleLabel.font = [UIFont chnRegularFontWithSize:12.0];
    [self.commentButton setTitle:GET_STRING(@"btn_comment") forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor cDarkYellowColor] forState:UIControlStateNormal];
    
    self.likeButton.layer.cornerRadius = 2.0;
    self.likeButton.titleLabel.font = [UIFont chnRegularFontWithSize:12.0];
    [self.likeButton setTitle:GET_STRING(@"btn_great") forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor cDarkYellowColor] forState:UIControlStateNormal];
}

- (void)setMedia:(Media *)media
{
    _media = media;
    self.nameLabel.text = media.creator.fullName;
    self.captionLabel.text = media.caption.text;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:media.images.standard.url] placeholderImage:[UIImage imageNamed:@"img_placeholder"] options:SDWebImageContinueInBackground];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:media.creator.profilePicture] placeholderImage:[UIImage imageNamed:@"user_placeholder"] options:SDWebImageContinueInBackground];
    self.timeLabel.text = [media.createdTime dateOffset];
    [self updateLikeButton:media.isLike];
}

- (void)updateLikeButton:(BOOL)like
{
    if (like) {
        [self.likeButton setImage:[UIImage imageNamed:@"ico_liked"] forState:UIControlStateNormal];
        [self.likeButton setBackgroundColor:[UIColor cLightYellowColor]];
        [self.likeAmountButton setTitle:[NSString stringWithFormat:@"%@ %@", @(self.media.totalLikes+1), GET_STRING(@"btn_great")] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ico_like"] forState:UIControlStateNormal];
        [self.likeButton setBackgroundColor:[UIColor cYellowColor]];
        [self.likeAmountButton setTitle:[NSString stringWithFormat:@"%@ %@", @(self.media.totalLikes), GET_STRING(@"btn_great")] forState:UIControlStateNormal];
    }
}

#pragma mark Action
- (IBAction)didLikeButtonClicked:(id)sender
{
    self.media.isLike = !self.media.isLike;
    [self updateLikeButton:self.media.isLike];
}

- (IBAction)didCommentButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(feedViewPhotoCell:didCommentButtonClicked:)]) {
        [self.delegate feedViewPhotoCell:self didCommentButtonClicked:sender];
    }
}

- (IBAction)didShareButtonClicked:(id)sender
{
}

- (IBAction)didLikeAmountButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(feedViewPhotoCell:didLikeAmountButtonClicked:)]) {
        [self.delegate feedViewPhotoCell:self didLikeAmountButtonClicked:sender];
    }
}

- (IBAction)didNameButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(feedViewPhotoCell:didNameButtonClicked:)]) {
        [self.delegate feedViewPhotoCell:self didNameButtonClicked:sender];
    }
}

@end
