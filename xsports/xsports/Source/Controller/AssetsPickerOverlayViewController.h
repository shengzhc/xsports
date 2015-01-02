//
//  AssetsPickerOverlayViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssetsPickerOverlayViewController;
@protocol AssetsPickerOverlayViewControllerDelegate <NSObject>
@optional
- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didBackButtonClicked:(id)sender;
- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didNextButtonClicked:(id)sender;
- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didSlidupButtonClicked:(id)sender;
@end

@interface AssetsPickerOverlayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *slideupButton;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) id < AssetsPickerOverlayViewControllerDelegate > delegate;
@end
