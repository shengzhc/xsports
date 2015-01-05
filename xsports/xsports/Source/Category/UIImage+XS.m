//
//  UIImage+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "UIImage+XS.h"

@implementation UIImage (XS)

+ (UIImage *)screenshot
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(mainWindow.bounds.size, NO, 0);
    [mainWindow drawViewHierarchyInRect:mainWindow.bounds afterScreenUpdates:YES];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

+ (UIImage *)blurScreenShot
{
    UIImage *screenshot = [UIImage screenshot];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:screenshot];
    GPUImageiOSBlurFilter *blurImageFilter = [[GPUImageiOSBlurFilter alloc] init];
    blurImageFilter.saturation = .5;
    blurImageFilter.downsampling = 6.0f;
    [stillImageSource addTarget:blurImageFilter];
    [blurImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *ret = [blurImageFilter imageFromCurrentFramebuffer];
    return ret;
}

- (UIImage *)blur
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self];
    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    [stillImageSource addTarget:blurFilter];
    [blurFilter useNextFrameForImageCapture];
    [stillImageSource processImage];

    return [blurFilter imageFromCurrentFramebuffer];
}

- (UIImage *)gaussianBlurImage
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self];
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 4.0;
    [stillImageSource addTarget:blurFilter];
    [blurFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    return [blurFilter imageFromCurrentFramebuffer];
}

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment
{
    return [UIImage alignImageWithImage:image text:text font:[UIFont regularFont] alignment:alignment leftPadding:0 topPadding:0];
}

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font alignment:(kImageTextAlignmentType)alignment
{
    return [UIImage alignImageWithImage:image text:text font:font alignment:alignment leftPadding:0 topPadding:0];
}

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding
{
    return [UIImage alignImageWithImage:image text:text font:[UIFont regularFont] alignment:alignment leftPadding:0 topPadding:0];
}

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding
{
    return [UIImage alignImageWithImage:image text:text font:font textColor:[UIColor whiteColor] alignment:alignment leftPadding:leftPadding topPadding:topPadding];
}

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding
{
    return [UIImage alignImageWithImage:image text:text font:font textColor:textColor alignment:alignment leftPadding:leftPadding topPadding:topPadding padding:2.0];
}

+ (UIImage *)alignImageWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor alignment:(kImageTextAlignmentType)alignment leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding padding:(CGFloat)padding
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: font};
    CGSize textSize = [text sizeWithAttributes:attributes];
    switch (alignment) {
        case kImageTextAlignmentTypeLeftRight:
        {
            CGSize size = CGSizeMake(image.size.width + textSize.width + padding + leftPadding * 2, (textSize.height > image.size.height ? textSize.height : image.size.height) + topPadding * 2);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            [image drawAtPoint:CGPointMake(leftPadding, (size.height - image.size.height)/2.0f)];
            [text drawAtPoint:CGPointMake(image.size.width + padding + leftPadding, (size.height - textSize.height)/2.0f) withAttributes:attributes];
            UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return ret;
        }
            break;
        case kImageTextAlignmentTypeRightLeft:
        {
            CGSize size = CGSizeMake(image.size.width + textSize.width + padding + leftPadding * 2, (textSize.height > image.size.height ? textSize.height : image.size.height) + topPadding * 2);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            [text drawAtPoint:CGPointMake(leftPadding, (size.height - textSize.height)/2.0f) withAttributes:attributes];
            [image drawAtPoint:CGPointMake(textSize.width + padding + leftPadding, (size.height - image.size.height)/2.0f)];
            UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return ret;
        }
            break;
        case kImageTextAlignmentTypeTopBottom:
        {
            CGSize size = CGSizeMake((textSize.width > image.size.width ? textSize.width : image.size.width) + topPadding * 2, textSize.height + image.size.height + padding + leftPadding * 2);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            [image drawAtPoint:CGPointMake((size.width - image.size.width)/2.0f, topPadding)];
            [text drawAtPoint:CGPointMake((size.width - textSize.width)/2.0f, image.size.height + padding + topPadding) withAttributes:attributes];
            UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return ret;
        }
            break;
        default:
            break;
    }
    return nil;
}

+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment
{
    return [UIImage alignBorderImageWithImage:image text:text alignment:alignment font:[UIFont regularFont]];
}

+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment backgroundColor:(UIColor *)color
{
    return [UIImage alignBorderImageWithImage:image text:text alignment:alignment font:[UIFont regularFont] backgroundColor:color];
}

+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment font:(UIFont *)font
{
    return [UIImage alignBorderImageWithImage:image text:text alignment:alignment font:font backgroundColor:nil];
}

+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment font:(UIFont *)font backgroundColor:(UIColor *)color
{
    return [UIImage alignBorderImageWithImage:image text:text alignment:alignment font:font backgroundColor:color leftPadding:6.0f topPadding:2.0f];
}

+ (UIImage *)alignBorderImageWithImage:(UIImage *)image text:(NSString *)text alignment:(kImageTextAlignmentType)alignment font:(UIFont *)font backgroundColor:(UIColor *)color leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)topPadding
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: font};
    CGSize textSize = [text sizeWithAttributes:attributes];
    CGFloat spacing = image ? 3.0 : 0;
    
    switch (alignment) {
        case kImageTextAlignmentTypeLeftRight:
        {
            CGRect rect = CGRectMake(0, 0, leftPadding * 2 + image.size.width + textSize.width + spacing, topPadding * 2 + (textSize.height > image.size.height ? textSize.height : image.size.height));
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
            if (color) {
                CGContextSetFillColorWithColor(contextRef, color.CGColor);
                [border fill];
            } else {
                CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
                CGContextSetLineWidth(contextRef, 2.0f);
                [border stroke];
            }
            [image drawAtPoint:CGPointMake(leftPadding, (rect.size.height - image.size.height)/2.0f)];
            [text drawAtPoint:CGPointMake(leftPadding + image.size.width + spacing, (rect.size.height - textSize.height)/2.0f) withAttributes:attributes];
            UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return ret;
        }
            break;
        case kImageTextAlignmentTypeRightLeft:
        {
            CGRect rect = CGRectMake(0, 0, leftPadding * 2 + image.size.width + textSize.width + spacing, topPadding * 2 + (textSize.height > image.size.height ? textSize.height : image.size.height));
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
            if (color) {
                CGContextSetFillColorWithColor(contextRef, color.CGColor);
                [border fill];
            } else {
                CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
                CGContextSetLineWidth(contextRef, 2.0f);
                [border stroke];
            }
            [text drawAtPoint:CGPointMake(leftPadding, (rect.size.height - textSize.height)/2.0f) withAttributes:attributes];
            [image drawAtPoint:CGPointMake(leftPadding + textSize.width + spacing, (rect.size.height - image.size.height)/2.0f)];
            UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return ret;
        }
            break;
        case kImageTextAlignmentTypeTopBottom:
        {
            CGRect rect = CGRectMake(0, 0, leftPadding * 2 + (textSize.width > image.size.width ? textSize.width : image.size.width), topPadding * 2 + textSize.height + image.size.height + spacing);
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
            if (color) {
                CGContextSetFillColorWithColor(contextRef, color.CGColor);
                [border fill];
            } else {
                CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
                CGContextSetLineWidth(contextRef, 2.0f);
                [border stroke];
            }
            [image drawAtPoint:CGPointMake((rect.size.width - image.size.width)/2.0f, topPadding)];
            [text drawAtPoint:CGPointMake((rect.size.width - textSize.width)/2.0f, topPadding + image.size.height + spacing) withAttributes:attributes];
            UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return ret;
        }
            break;
        default:
            break;
    }
    return nil;
}


@end
