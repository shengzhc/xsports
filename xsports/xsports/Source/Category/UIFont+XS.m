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
    return [self regularFontWithSize:16.0];
}

+ (UIFont *)boldFont
{
    return [self boldFontWithSize:16.0];
}

+ (UIFont *)thinFont
{
    return [self thinFontWithSize:16.0];
}

+ (UIFont *)regularFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Regular" size:size];
    return font;
}

+ (UIFont *)boldFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Bold" size:size];
    return font;
}

+ (UIFont *)thinFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Thin" size:size];
    return font;
}


@end
