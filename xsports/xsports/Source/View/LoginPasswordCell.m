//
//  LoginPasswordCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LoginPasswordCell.h"

@implementation LoginPasswordCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    UIFont *font = [UIFont regularFont];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor textFieldPlaceHolderColor]};
    NSMutableAttributedString *placeholderText = [[NSMutableAttributedString alloc] initWithString:[self placeHolderText] attributes:attributes];
    self.textField.attributedPlaceholder = placeholderText;
    
    self.textField.tintColor = [UIColor textFieldCursorColor];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = font;
}

- (NSString *)placeHolderText
{
    return @"密码";
}

@end
