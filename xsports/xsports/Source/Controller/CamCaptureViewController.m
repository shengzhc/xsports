//
//  CamCaptureViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureViewController.h"

@interface CamCaptureViewController () < CamCaptureModeViewControllerDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@end

@implementation CamCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.curtainViewController openCurtainWithCompletionHandler:nil];
}

- (void)setup
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
    self.modeViewController.delegate = self;
}

#pragma mark CamCaptureModeViewControllerDelegate
- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didEndDisplayingPageAtIndex:(NSInteger)pageIndex
{
    [self.curtainViewController openCurtainWithCompletionHandler:^{
        if (pageIndex == 1) {
            [self.overlayViewController.progressView startAnimation];
        }
    }];
}

- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didScrollWithPercentage:(CGFloat)percentage toPage:(NSUInteger)pageIndex
{
    [self.curtainViewController openCurtainWithPercent:percentage];
    [self.overlayViewController transitionWithPercent:percentage toPageIndex:pageIndex];
    
    [self.overlayViewController.progressView stopAnimation];
}

- (void)camCaptureModeViewController:(CamCaptureModeViewController *)controller didScrollWithPercentage:(CGFloat)percentage
{

//    CGFloat f = 1 - (c - self.camScrollView.contentOffset.x)/c;
//    self.progressView.alpha = MAX(MIN(f, 1.0), 0);;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CamCaptureOverlayViewControllerSegueIdentifier]) {
        self.overlayViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CamCaptureModeViewControllerSegueIdentifier]) {
        self.modeViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CamCurtainViewControllerSegueIdentifier]) {
        self.curtainViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}


@end
