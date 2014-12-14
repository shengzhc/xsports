//
//  FeedViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController () < UICollectionViewDelegate, UICollectionViewDataSource >
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.flowLayout.itemSize.width != self.collectionView.bounds.size.width) {
        self.flowLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width, 500.0);
        [self.flowLayout invalidateLayout];
    }
}

#pragma mark Action
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewPhotoCellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
