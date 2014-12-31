//
//  CamCaptureViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCaptureViewController.h"

@interface CamCaptureViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@end

@implementation CamCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setup
{
    self.topHeightConstraint.constant = [UIScreen width] + 44 + 56;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CamCaptureOverlayViewControllerSegueIdentifier]) {
        self.overlayViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CamCaptureModeViewControllerSegueIdentifier]) {
        self.curtainViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CamCurtainViewControllerIdentifier]) {
        self.curtainViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}


@end
