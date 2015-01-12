//
//  AssetsPickerViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/22/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "AssetsPickerViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "ELCAssetsCollector.h"

static void *AssetsCollectionIsReadyContext = &AssetsCollectionIsReadyContext;

@interface AssetsPickerViewController () < AssetsPickerOverlayViewControllerDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) ELCAssetsCollector *assetsCollector;
@property (copy, nonatomic) void (^completionHandler)(void);
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

- (void)dealloc
{
    if (self.assetsCollector) {
        [self removeObserver:self forKeyPath:@"assetsCollector.isReady"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AssetsCollectionIsReadyContext) {
        if ([change[NSKeyValueChangeNewKey] boolValue]) {
            if (self.completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.completionHandler();
                    self.completionHandler = nil;
                });
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Setup
- (void)setupViews
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
}

- (void)prepareAssetsWithCompletionHandler:(void (^)(void))completionHandler
{
    self.assetsCollector = [[ELCAssetsCollector alloc] init];
    self.assetsCollector.mediaTypes = self.mode == kAssetsPickerModeVideo ? @[(NSString *)kUTTypeMovie] : @[];
    [self.assetsCollector addObserver:self forKeyPath:@"isReady" options:NSKeyValueObservingOptionNew context:AssetsCollectionIsReadyContext];
    [self.assetsCollector loadAssetsGroup];
    self.completionHandler = completionHandler;
}

//- (void)prepareWithCompletionHandler:(void (^)(void))completionHandler
//{
//    [self.albumPickerController view];
//    [self.albumPickerController.navigationController pushViewController:self.albumPickerController.assetsCollectionViewController animated:NO];
//    if (completionHandler) {
//        completionHandler();
//    }
//}

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
        self.albumPickerController.mediaTypes = self.mode == kAssetsPickerModeVideo ? @[(NSString *)kUTTypeMovie] : @[];
    } else if ([segue.identifier isEqual:CamCurtainViewControllerSegueIdentifier]) {
        self.camCurtainViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

@end
