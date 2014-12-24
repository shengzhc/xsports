//
//  UIFont+XS.h
//  xsports
//
//  Created by Shengzhe Chen on 12/10/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (XS)

+ (UIFont *)chnRegularFont;
+ (UIFont *)regularFont;
+ (UIFont *)lightFont;
+ (UIFont *)boldFont;
+ (UIFont *)extraLightFont;
+ (UIFont *)semiBoldFont;

+ (UIFont *)regularFontWithSize:(CGFloat)size;
+ (UIFont *)boldFontWithSize:(CGFloat)size;
+ (UIFont *)lightFontWithSize:(CGFloat)size;
+ (UIFont *)extraLightFontWithSize:(CGFloat)size;
+ (UIFont *)semiBoldFontWithSize:(CGFloat)size;
+ (UIFont *)chnRegularFontWithSize:(CGFloat)size;
@end
