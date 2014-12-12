//
//  UIFont+XS.h
//  xsports
//
//  Created by Shengzhe Chen on 12/10/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (XS)

+ (UIFont *)regularFont;
+ (UIFont *)thinFont;
+ (UIFont *)boldFont;

+ (UIFont *)regularFontWithSize:(CGFloat)size;
+ (UIFont *)boldFontWithSize:(CGFloat)size;
+ (UIFont *)thinFontWithSize:(CGFloat)size;

+ (UIFont *)mediumEngFont;
+ (UIFont *)mediumEngFontWithSize:(CGFloat)size;

@end
