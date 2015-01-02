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

typedef enum : NSUInteger {
    kAssetsPickerModePhoto,
    kAssetsPickerModeVideo
} kAssetsPickerMode;

@interface AssetsPickerViewController : UIViewController
@property (assign, nonatomic) kAssetsPickerMode mode;
@property (strong, nonatomic) ELCAlbumPickerController *albumPickerController;
@property (strong, nonatomic) AssetsPickerOverlayViewController *overlayViewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayLeadingConstraint;


- (void)prepareWithCompletionHandler:(void (^)(void))completionHandler;

@end
