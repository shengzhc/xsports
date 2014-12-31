//
//  CamCaptureViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamCaptureOverlayViewController.h"
#import "CamCurtainViewController.h"
#import "CamCaptureModeViewController.h"
#import "AVCamPreviewView.h"

@interface CamCaptureViewController : UIViewController
@property (strong, nonatomic) CamCaptureOverlayViewController *overlayViewController;
@property (strong, nonatomic) CamCaptureModeViewController *modeViewController;
@property (strong, nonatomic) CamCurtainViewController *curtainViewController;
@end
