//
//  CamCaptureViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamCaptureOverlayViewController.h"
#import "AVCamPreviewView.h"

@interface CamCaptureViewController : UIViewController
@property (strong, nonatomic) CamCaptureOverlayViewController *overlayViewController;
@property (weak, nonatomic) IBOutlet AVCamPreviewView *previewView;
@end
