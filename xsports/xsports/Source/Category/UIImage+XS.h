//
//  UIImage+XS.h
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kImageTextAlignmentTypeLeftRight,
    kImageTextAlignmentTypeRightLeft,
    kImageTextAlignmentTypeTopBottom
} kImageTextAlignmentType;

@interface UIImage (XS)
+ (UIImage *)screenshot;
+ (UIImage *)blurScreenShot;
- (UIImage *)blur;

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment;
+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font alignment:(kImageTextAlignmentType)alignment;
+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding;
+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding;
+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding padding:(CGFloat)padding;
+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment;
+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment font:(UIFont *)font;
+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment backgroundColor:(UIColor *)color;
+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment font:(UIFont *)font backgroundColor:(UIColor *)color leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding;

@end
