//
//  UINavigationController+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/13/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "UINavigationController+XS.h"

@implementation UINavigationController (XS)

- (void)clearBackground
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor clearColor];
}

@end
