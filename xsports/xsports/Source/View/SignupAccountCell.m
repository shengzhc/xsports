//
//  SignupAccountCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SignupAccountCell.h"

@implementation SignupAccountCell

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
    return GET_STRING(@"name");
}

@end
