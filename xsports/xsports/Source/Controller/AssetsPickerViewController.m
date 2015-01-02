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
@end

@implementation AssetsPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
}

#pragma mark AssetsPickerOverlayViewControllerDelegate
- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didBackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didNextButtonClicked:(id)sender
{
    
}

- (void)assetsPickerOverlayViewControlelr:(AssetsPickerOverlayViewController *)controller didSlidupButtonClicked:(id)sender
{
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AssetsPickerOverlayViewControllerSegueIdentifier]) {
        self.overlayViewController = segue.destinationViewController;
        self.overlayViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:Nav_ELCAssetsCollectionViewControllerSegueIdentifier]) {
        UINavigationController *nav = segue.destinationViewController;
        self.albumPickerController = [nav.viewControllers objectAtIndex:0];
        self.albumPickerController.mediaTypes = self.mode == kAssetsPickerModeVideo ? @[(NSString *)kUTTypeMovie] : @[];
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

@end
