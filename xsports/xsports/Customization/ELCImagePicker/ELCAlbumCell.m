//
//  ELCAlbumCell.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "ELCAlbumCell.h"

@implementation ELCAlbumCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.albumImageView.layer.cornerRadius = 2.0;
    self.albumImageView.layer.masksToBounds = YES;
    self.albumTitleLabel.font = [UIFont chnRegularFont];
    self.albumTitleLabel.textColor = [UIColor whiteColor];
    self.albumTitleLabel.text = nil;
    self.assetsCountLabel.font = [UIFont chnRegularFont];
    self.assetsCountLabel.textColor = [UIColor cLightGrayColor];
    self.assetsCountLabel.text = @">";
}

@end
