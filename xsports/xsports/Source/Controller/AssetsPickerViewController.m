//
//  AssetsPickerViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/22/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "AssetsPickerViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface AssetsPickerViewController () < AssetsPickerOverlayViewControllerDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation AssetsPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.camCurtainViewController openCurtainWithCompletionHandler:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.camCurtainViewController closeCurtainWithCompletionHandler:nil];
}

#pragma mark Setup
- (void)setupViews
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
}

#pragma mark AssetsPickerOverlayViewControllerDelegate
- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didBackButtonClicked:(id)sender
{
    [self.camCurtainViewController closeCurtainWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didNextButtonClicked:(id)sender
{
    
}

- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didSlidupButtonClicked:(id)sender
{
    CGFloat constant = self.topConstraint.constant == 0 ? (0 - self.topHeightConstraint.constant + 24 + 50) : 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.topConstraint.constant = constant;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topConstraint.constant = constant;
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AssetsPickerOverlayViewControllerSegueIdentifier]) {
        self.overlayViewController = segue.destinationViewController;
        self.overlayViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:Nav_ELCAssetsCollectionViewControllerSegueIdentifier]) {
        UINavigationController *nav = segue.destinationViewController;
        self.albumPickerController = [nav.viewControllers objectAtIndex:0];
        self.albumPickerController.mode = (kAssetsPickerMode)(self.mode);
    } else if ([segue.identifier isEqual:CamCurtainViewControllerSegueIdentifier]) {
        self.camCurtainViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

@end
