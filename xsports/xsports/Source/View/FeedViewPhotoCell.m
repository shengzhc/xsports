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
    self.profileImageView.layer.cornerRadius = 4.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont boldFontWithSize:16];
    self.nameLabel.textColor = [UIColor fujiColor];
    self.timeLabel.font = [UIFont regularFont];
    self.timeLabel.textColor = [UIColor darkFujiColor];
    self.topSeperator.backgroundColor = [UIColor pebbleColor];
    
    self.likeAmountButton.titleLabel.font = [UIFont regularFont];
    [self.likeAmountButton setTitleColor:[UIColor semiWaveColor] forState:UIControlStateNormal];
    self.captionLabel.font = [UIFont regularFontWithSize:12.0];
    self.captionLabel.textColor = [UIColor semiTempuraColor];
    
    self.shareButton.layer.cornerRadius = 4.0;
    [self.shareButton setBackgroundColor:[UIColor lightGrayColor]];

    self.commentButton.layer.cornerRadius = 4.0;
    [self.commentButton setBackgroundColor:[UIColor lightGrayColor]];
    self.commentButton.titleLabel.font = [UIFont regularFont];
    [self.commentButton setTitleColor:[UIColor fujiColor] forState:UIControlStateNormal];
    
    self.likeButton.layer.cornerRadius = 4.0;
    [self.likeButton setBackgroundColor:[UIColor lightGrayColor]];
    self.likeButton.titleLabel.font = [UIFont regularFont];
    [self.likeButton setTitleColor:[UIColor fujiColor] forState:UIControlStateNormal];
}

- (void)setMedia:(Media *)media
{
    _media = media;
    self.nameLabel.text = media.creator.fullName;
    self.captionLabel.text = media.caption.text;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:media.images.standard.url] placeholderImage:nil options:SDWebImageContinueInBackground];
    self.timeLabel.text = [media.createdTime dateOffset];
    [self updateLikeButton:media.isLike];
}

- (void)updateLikeButton:(BOOL)like
{
    if (like) {
        [self.likeButton setImage:[UIImage imageNamed:@"ico_heart_purple.png"] forState:UIControlStateNormal];
        [self.likeButton setTitle:@"Liked" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor coralColor] forState:UIControlStateNormal];
        [self.likeAmountButton setTitle:[NSString stringWithFormat:@"%@", @(self.media.totalLikes+1)] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ico_empty_heart_purple.png"] forState:UIControlStateNormal];
        [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor fujiColor] forState:UIControlStateNormal];
        [self.likeAmountButton setTitle:[NSString stringWithFormat:@"%@", @(self.media.totalLikes)] forState:UIControlStateNormal];

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
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)didShareButtonClicked:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
