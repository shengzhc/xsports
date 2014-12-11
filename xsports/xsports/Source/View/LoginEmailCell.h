//
//  LoginTextFieldCell.h
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginEmailCell : UITableViewCell < UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet UIImageView *warningImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
