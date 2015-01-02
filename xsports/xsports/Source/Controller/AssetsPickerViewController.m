//
//  AssetsPickerViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/22/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "AssetsPickerViewController.h"

@interface AssetsPickerViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@end

@implementation AssetsPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
}

@end
