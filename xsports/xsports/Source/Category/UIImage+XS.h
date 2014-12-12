//
//  UIImage+XS.h
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XS)
+ (UIImage *)screenshot;
+ (UIImage *)blurScreenShot;

- (UIImage *)blur;
@end
