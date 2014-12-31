//
//  CamCurtainViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamCurtainViewController.h"

@interface CamCurtainViewController ()

@end

@implementation CamCurtainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)closeCurtainWithCompletionHandler:(void (^)(void))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.openLayoutConstraint.constant = 0;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completionHandler) {
                completionHandler();
            }
        }];
    });
}

- (void)openCurtainWithCompletionHandler:(void (^)(void))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = self.view.bounds.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            self.openLayoutConstraint.constant = height;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completionHandler) {
                completionHandler();
            }
        }];
    });
}

@end