//
//  UIFont+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/10/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "UIFont+XS.h"

@implementation UIFont (XS)

+ (UIFont *)regularFont
{
    return [self regularFontWithSize:14.0];
}

+ (UIFont *)boldFont
{
    return [self boldFontWithSize:14.0];
}

+ (UIFont *)lightFont
{
    return [self lightFontWithSize:14.0];
}

+ (UIFont *)extraLightFont
{
    return [self extraLightFontWithSize:14.0];
}

+ (UIFont *)semiBoldFont
{
    return [self semiBoldFontWithSize:14.0];
}

+ (UIFont *)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SourceSansPro-Bold" size:size];
}

+ (UIFont *)lightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SourceSansPro-Light" size:size];
}

+ (UIFont *)extraLightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SourceSansPro-ExtraLight" size:size];
}

+ (UIFont *)semiBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SourceSansPro-Semibold" size:size];
}

@end
