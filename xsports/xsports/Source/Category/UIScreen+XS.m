//
//  UIScreen+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "UIScreen+XS.h"

@implementation UIScreen (XS)

+ (CGFloat)height
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)width
{
    return [UIScreen mainScreen].bounds.size.width;
}

@end
