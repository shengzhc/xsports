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
    NSMutableDictionary *prev = [NSMutableDictionary new];
    UIImage *backgroundImage = [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    prev[@"bg"] = backgroundImage ? backgroundImage : [NSNull null];
    prev[@"shd"] = self.navigationBar.shadowImage ? self.navigationBar.shadowImage : [NSNull null];
    prev[@"bgc"] = self.view.backgroundColor ? self.view.backgroundColor : [UIColor clearColor];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor clearColor];

    objc_setAssociatedObject(self, @"prev", prev, OBJC_ASSOCIATION_RETAIN);
}

- (void)restoreBackground
{
    NSDictionary *prev = objc_getAssociatedObject(self, @"prev");
    [self.navigationBar setBackgroundImage:prev[@"bg"] != [NSNull null] ? prev[@"bg"] : nil forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = prev[@"shd"] != [NSNull null] ? prev[@"shd"] : nil;
    self.view.backgroundColor = prev[@"bgc"];
}

@end
