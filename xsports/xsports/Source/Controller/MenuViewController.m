//
//  MenuViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupImageView];
    [self setupLabel];
}

- (void)setupLabel
{
    self.nameLabel.font = [UIFont mediumEngFont];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = @"Frank Rapacciuolo";
    self.locationLabel.font = [UIFont mediumEngFontWithSize:14.0];
    self.locationLabel.textColor = [UIColor lightPebbleColor];
    self.locationLabel.text = @"San Francisco";
}

- (void)setupImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2.0;
}

@end
