//
//  CamCaptureModeViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamScrollView.h"

@class CamCaptureModeViewController;
@protocol CamCaptureModeViewControllerDelegate <NSObject>
@optional
- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didScrollWithPercentage:(CGFloat)percentage;
- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didEndDisplayingPageAtIndex:(NSInteger)pageIndex;
@end

@interface CamCaptureModeViewController : UIViewController
@property (weak, nonatomic) IBOutlet CamScrollView *scrollView;
@property (weak, nonatomic) id < CamCaptureModeViewControllerDelegate > delegate;
@end
