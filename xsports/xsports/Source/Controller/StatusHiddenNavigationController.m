//
//  StatusHiddenNavigationController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/21/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "StatusHiddenNavigationController.h"

@interface StatusHiddenNavigationController ()
@property (assign, nonatomic) BOOL isStatusBarHidden;
@end

@implementation StatusHiddenNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:self.isStatusBarHidden];
}
@end
