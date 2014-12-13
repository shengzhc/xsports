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
    self.iconTextLabel.font = [UIFont mediumEngFontWithSize:18.0];
    self.iconTextLabel.textColor = [UIColor whiteColor];
}

- (void)setupImageView
{
}

@end
