//
//  SettingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/13/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SettingViewController.h"

@implementation SettingViewController


#pragma Action
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
