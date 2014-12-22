//
//  SettingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/13/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma Action
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
