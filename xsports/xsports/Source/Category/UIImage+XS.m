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
    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 30.0;
    return [blurFilter imageByFilteringImage: self];
}

@end
