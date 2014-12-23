//
//  CamScrollView.h
//  xsports
//
//  Created by Shengzhe Chen on 12/22/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamScrollView : UIScrollView
@property (strong, nonatomic) UIButton *picGalleryButton;
@property (strong, nonatomic) UIButton *stillCaptureButton;
@property (strong, nonatomic) UIButton *mediaSwitchButton;
@property (strong, nonatomic) UIButton *recordCaptureButton;
@property (strong, nonatomic) UIButton *videoGalleryButton;

- (CGRect)rectAtPage:(NSInteger)pageIndex;
- (NSInteger)pageOfContentOffset:(CGPoint)contentOffset;
- (void)didScrollEndAtPageIndex:(NSInteger)pageIndex;

@end
