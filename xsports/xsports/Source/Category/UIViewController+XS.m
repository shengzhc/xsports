//
//  UIViewController+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "UIViewController+XS.h"

@implementation UIViewController (XS)

- (SIAlertView *)cancelAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:@"Close" type:SIAlertViewButtonTypeCancel handler:nil];
    [alertView setTitleFont:[UIFont fontWithName:@"Futura-Medium" size:16.0]];
    [alertView setTitleColor:[UIColor fujiColor]];
    [alertView setMessageFont:[UIFont fontWithName:@"Futura-Medium" size:16.0]];
    [alertView setMessageColor:[UIColor fujiColor]];
    [alertView setButtonFont:[UIFont fontWithName:@"Futura-Medium" size:18.0]];
    [alertView setCancelButtonColor:[UIColor coralColor]];
    alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
    alertView.didDismissHandler = ^(SIAlertView *alertView){ [alertView removeFromSuperview];};
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    return alertView;
}

@end
