//
//  FeedPopoverContentCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/29/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedPopoverContentCell.h"

@implementation FeedPopoverContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentTextLabel.font = [UIFont chnRegularFont];
    self.contentTextLabel.textColor = [UIColor cLightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentTextLabel.textColor = [UIColor cYellowColor];
    } else {
        self.contentTextLabel.textColor = [UIColor cLightGrayColor];
    }
}

@end
