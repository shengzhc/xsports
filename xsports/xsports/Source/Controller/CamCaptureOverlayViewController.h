//
//  CamCaptureOverlayViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"

@interface CamCaptureOverlayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;

- (IBAction)didCloseButtonClicked:(id)sender;
- (IBAction)didNextButtonClicked:(id)sender;
- (IBAction)didGridButtonClicked:(id)sender;
- (IBAction)didRotateButtonClicked:(id)sender;
- (IBAction)didFlashButtonClicked:(id)sender;

- (void)transitionWithPercent:(CGFloat)percent toPageIndex:(NSUInteger)pageIndex;
- (void)didEndTransitionToPageIndex:(NSUInteger)pageIndex;

@end
