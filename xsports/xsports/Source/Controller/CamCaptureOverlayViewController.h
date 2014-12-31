//
//  CamCaptureOverlayViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"

@class CamCaptureOverlayViewController;
@protocol CamCaptureOverlayViewControllerDelegate <NSObject>
@optional
- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didCloseButtonClicked:(id)sender;
- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didNextButtonClicked:(id)sender;
- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didGridButtonClicked:(id)sender;
- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didRotateButtonClicked:(id)sender;
- (void)camCaptureOverlayViewController:(CamCaptureOverlayViewController *)controller didFlashButtonClicked:(id)sender;
@end

@interface CamCaptureOverlayViewController : UIViewController

@property (assign, nonatomic) AVCaptureFlashMode flashMode;
@property (assign, nonatomic) BOOL isGridEnabled;

@property (weak, nonatomic) id < CamCaptureOverlayViewControllerDelegate > delegate;
- (void)transitionWithPercent:(CGFloat)percent toPageIndex:(NSUInteger)pageIndex;
- (void)didEndTransitionToPageIndex:(NSUInteger)pageIndex;

@end
