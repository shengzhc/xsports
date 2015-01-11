//
//  FeedDetailViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 1/10/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "FeedDetailViewController.h"

@implementation FeedDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.bounces = NO;
    self.view.backgroundColor = [UIColor cGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self setupNavigationBar];
        self.collectionView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
    }
}

- (void)setupNavigationBar
{
    Media *media = (Media *)self.feeds[0];
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = media.isVideo ? GET_STRING(@"video") : GET_STRING(@"photo");
    titleView.font = [UIFont chnRegularFontWithSize:20];
    titleView.textColor = [UIColor cLightGrayColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didBackBarButtonItemClicked:)];
    [backBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem];
}

#pragma mark Action
- (void)didBackBarButtonItemClicked:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
