//
//  AssetsPickerOverlayViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "AssetsPickerOverlayViewController.h"

@interface AssetsPickerOverlayViewController ()

@end

@implementation AssetsPickerOverlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    self.topBar.backgroundColor = [[UIColor cSuperDarkBlackColor] colorWithAlphaComponent:0.9];
    self.toolBar.backgroundColor = [[UIColor cSuperDarkBlackColor] colorWithAlphaComponent:0.9];
    
    self.titleLabel.font = [UIFont chnRegularFontWithSize:16];
    self.titleLabel.textColor = [UIColor cLightGrayColor];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark Action
- (IBAction)didBackButtonClicked:(id)sender
{
}

- (IBAction)didNextButtonClicked:(id)sender
{
}

- (IBAction)didSlideUpButtonClicked:(id)sender
{
}

@end