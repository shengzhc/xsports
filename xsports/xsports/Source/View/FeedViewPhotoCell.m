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
    self.nameLabel.font = [UIFont mediumEngFont];
    self.nameLabel.textColor = [UIColor fujiColor];
    self.timeLabel.font = [UIFont mediumEngFontWithSize:14];
    self.timeLabel.textColor = [UIColor darkFujiColor];
    self.topSeperator.backgroundColor = [UIColor darkPebbleColor];
    
    self.likeAmountButton.titleLabel.font = [UIFont mediumEngFont];
    [self.likeAmountButton setTitleColor:[UIColor semiWaveColor] forState:UIControlStateNormal];
    self.captionLabel.font = [UIFont mediumEngFontWithSize:12.0];
    self.captionLabel.textColor = [UIColor semiTempuraColor];
}

- (void)setMedia:(Media *)media
{
    _media = media;
    self.nameLabel.text = media.creator.fullName;
    self.captionLabel.text = media.caption.text;
}

@end
