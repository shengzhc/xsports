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
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://scontent-b.cdninstagram.com/hphotos-xaf1/t50.2886-16/10871617_612834772177355_898098286_n.mp4"]];
    [self.playerView setPlayer:player];
    [player play];
}


#pragma Action
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
