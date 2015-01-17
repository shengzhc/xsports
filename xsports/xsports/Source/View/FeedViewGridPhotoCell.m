//
//  FeedViewGridPhotoCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/16/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewGridPhotoCell.h"

@implementation FeedViewGridPhotoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor cYellowColor];
}

- (void)setMedia:(Media *)media
{
    _media = media;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:media.images.standard.url] placeholderImage:[UIImage imageNamed:@"img_placeholder"] options:SDWebImageContinueInBackground];
}

@end
