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

#import "SinkingAndPoppingAnimator.h"
#import "CECardsAnimationController.h"
#import "CamCaptureAssetsAnimator.h"

@interface CamNavigationControllerTransitioningDelegate : NSObject  < UIViewControllerTransitioningDelegate >
@end

@implementation CamNavigationControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    SinkingAndPoppingAnimator *animator = [[SinkingAndPoppingAnimator alloc] init];
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SinkingAndPoppingAnimator *animator = [[SinkingAndPoppingAnimator alloc] init];
    animator.reverse = YES;
    return animator;
}

@end


@interface CamNavigationController () < UINavigationControllerDelegate >
@property (assign, nonatomic) BOOL isStatusBarHidden;
@property (strong, nonatomic) CamNavigationControllerTransitioningDelegate *navTransitioningDelegate;
@end

@implementation CamNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.navTransitioningDelegate = [[CamNavigationControllerTransitioningDelegate alloc] init];
    self.transitioningDelegate = self.navTransitioningDelegate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
