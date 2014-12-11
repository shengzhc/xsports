//
//  LoginTextFieldCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LoginEmailCell.h"

@implementation LoginEmailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.textField.tintColor = [UIColor semiFujiColor];
}

@end
