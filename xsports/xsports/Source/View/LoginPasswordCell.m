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
    UIFont *font = [UIFont fontWithName:@"Futura-Medium" size:16.0];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor textFieldPlaceHolderColor]};
    NSMutableAttributedString *placeholderText = [[NSMutableAttributedString alloc] initWithString:[self placeHolderText] attributes:attributes];
    self.textField.attributedPlaceholder = placeholderText;
    
    self.textField.tintColor = [UIColor textFieldCursorColor];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = font;
}

- (NSString *)placeHolderText
{
    return @"Password";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *password = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ((password && password.length >= 4) || (password.length == 0)) {
        if (self.warningImageView.alpha != 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.warningImageView.alpha = 0;
            }];
        }
    } else {
        if (self.warningImageView.alpha != 1.0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.warningImageView.alpha = 1.0;
            }];
        }
    }
    
    if (password.length >= 12) {
        return NO;
    }
    
    return YES;
}


@end
