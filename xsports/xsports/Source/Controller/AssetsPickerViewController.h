//
//  AssetsPickerViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/22/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAlbumPickerController.h"
#import "AssetsPickerOverlayViewController.h"
#import "CamCurtainViewController.h"

@interface AssetsPickerViewController : UIViewController
@property (strong, nonatomic) ELCAlbumPickerController *albumPickerController;
@property (strong, nonatomic) AssetsPickerOverlayViewController *overlayViewController;
@property (strong, nonatomic) CamCurtainViewController *camCurtainViewController;
@property (assign, nonatomic) kAssetsPickerMode mode;

@property (weak, nonatomic) IBOutlet UIView *overlayContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIView *curtainContainer;

@end
