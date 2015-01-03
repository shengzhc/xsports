//
//  StatusHiddenNavigationController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/21/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamNavigationController.h"
#import "CamCaptureViewController.h"
#import "AssetsPickerViewController.h"

#import "CamCaptureAssetsAnimator.h"

@interface CamNavigationController () < UINavigationControllerDelegate >
@property (assign, nonatomic) BOOL isStatusBarHidden;
@end

@implementation CamNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:self.isStatusBarHidden];
}

#pragma mark UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([fromVC isKindOfClass:[CamCaptureViewController class]] && [toVC isKindOfClass:[AssetsPickerViewController class]]) {
        CamCaptureAssetsAnimator *animator = [[CamCaptureAssetsAnimator alloc] init];
        animator.operation = operation;
        return animator;
    }
    
    if ([fromVC isKindOfClass:[AssetsPickerViewController class]] && [toVC isKindOfClass:[CamCaptureViewController class]]) {
        CamCaptureAssetsAnimator *animator = [[CamCaptureAssetsAnimator alloc] init];
        animator.operation = operation;
        return animator;
    }
    
    return nil;
}

@end
