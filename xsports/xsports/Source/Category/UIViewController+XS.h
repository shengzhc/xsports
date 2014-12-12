//
//  UIViewController+XS.h
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"

@interface UIViewController (XS)

- (SIAlertView *)cancelAlertViewWithTitle:(NSString *)title message:(NSString *)message;
- (LoadingViewController *)showLoadingIndicator;

@end
