//
//  SlidingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SlidingViewController.h"

@implementation SlidingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.menuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:MenuViewControllerIdentifier];
    self.underLeftViewController = self.menuViewController;
    [self.menuViewController select:kMenuItemNew animated:NO];
}

@end
