//
//  MenuViewCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "MenuViewCell.h"

@implementation MenuViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupLabel];
    [self setupImageView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLabel];
    }
    
    return self;
}

- (void)setupLabel
{
    self.iconTextLabel.font = [UIFont chnRegularFontWithSize:12];
    [self.iconTextLabel setTextColor:[UIColor cLightGrayColor]];
    [self.iconTextLabel setHighlightedTextColor:[UIColor cYellowColor]];
}

- (void)setupImageView
{
    self.topSeperator.backgroundColor = self.seperator.backgroundColor = [[UIColor cLightGrayColor] colorWithAlphaComponent:0.9];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.iconImageView setHighlighted:selected];
    [self.iconTextLabel setHighlighted:selected];
}

@end
