//
//  LoadingViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()
@property (strong, nonatomic) LoadingTransitioningDelegate *loadingTransitionDelegate;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation LoadingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupTransitioningDelegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabel];
    [self setupLoadingImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self animate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self animate];
}

- (void)setupTransitioningDelegate
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.loadingTransitionDelegate = [[LoadingTransitioningDelegate alloc] init];
    self.transitioningDelegate = self.loadingTransitionDelegate;
}

- (void)setupLabel
{
    self.loadingLabel.font = [UIFont regularFontWithSize:22.0];
    self.loadingLabel.textColor = [UIColor fujiColor];
}

- (void)setupLoadingImageView
{
    NSMutableArray *imageArray = [NSMutableArray new];
    NSString *baseStr = @"ico_power_0";
    for (int i=0; i<4; i++) {
        NSString *str = [NSString stringWithFormat:@"%@%@", baseStr, @(i)];
        UIImage *image = [UIImage imageNamed:str];
        if (image) {
            [imageArray addObject:image];
        }
    }
    self.loadingImageView.animationImages = imageArray;
    self.loadingImageView.animationDuration = 2.0;
    self.loadingImageView.animationRepeatCount = 0;
}

- (void)animate
{
    [self.loadingImageView startAnimating];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
    }
}

- (void)stop
{
    [self.loadingImageView stopAnimating];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateLabel:(id)sender
{
    static NSUInteger count = 0;
    NSString *dots = @"";
    switch (count) {
        case 1:
            dots = @".";
            break;
        case 2:
            dots = @"..";
            break;
        case 3:
            dots = @"...";
            break;
        default:
            break;
    }
    self.loadingLabel.text = [NSString stringWithFormat:@"Loading%@", dots];
    count = (count+1)%4;
}

@end
