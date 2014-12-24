//
//  ProgressView.h
//  xsports
//
//  Created by Shengzhe Chen on 12/23/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
@property (strong, nonatomic) UIView *cursorView;
@property (strong, nonatomic) UIView *seperatorView;
@property (strong, nonatomic) UIView *progressView;
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) CGFloat seperator;

- (void)startAnimation;
- (void)stopAnimation;
@end
