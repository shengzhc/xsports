//
//  FeedFlowCollectionViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/17/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedFlowCollectionViewController.h"
#import "FeedViewPhotoCell.h"
#import "FeedViewVideoCell.h"

@interface FeedFlowCollectionViewController () < UICollectionViewDelegateFlowLayout >
@property (strong, nonatomic) NSDictionary *prototypes;
@end

@implementation FeedFlowCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewVideoCellIdentifier];
    [self preparePrototypes];
}

- (void)preparePrototypes
{
    NSMutableDictionary *prototypes = [NSMutableDictionary new];
    id cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedViewPhotoCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[FeedViewPhotoCellIdentifier] = cell;
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedViewVideoCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[FeedViewVideoCellIdentifier] = cell;
    
    self.prototypes = prototypes;
}

- (void)setFeeds:(NSArray *)feeds
{
    _feeds = feeds;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.feeds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    UICollectionViewCell *cell = nil;
    if ([media isVideo]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewVideoCellIdentifier forIndexPath:indexPath];
        ((FeedViewVideoCell *)cell).media = self.feeds[indexPath.item];
        
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewPhotoCellIdentifier forIndexPath:indexPath];
        ((FeedViewPhotoCell *)cell).media = self.feeds[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    if ([media isVideo]) {
        for (UICollectionViewCell *item in collectionView.visibleCells) {
            if ([item isKindOfClass:[FeedViewVideoCell class]]) {
                [((FeedViewVideoCell *)cell) pause];
            }
        }
//        [((FeedViewVideoCell *)cell) play];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    if ([media isVideo]) {
        [((FeedViewVideoCell *)cell) clear];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    if (media.flowLayoutHeight == 0) {
        FeedViewPhotoCell *cell = nil;
        if ([media isVideo]) {
            cell = self.prototypes[FeedViewVideoCellIdentifier];
        } else {
            cell = self.prototypes[FeedViewPhotoCellIdentifier];
        }
        cell.frame = CGRectMake(0, 0, collectionView.bounds.size.width, 10000);
        cell.media = self.feeds[indexPath.item];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGSize size = CGSizeMake(collectionView.bounds.size.width, cell.bottomContainer.frame.origin.y + cell.bottomContainer.frame.size.height);
        size.width = ceilf(size.width);
        size.height = ceilf(size.height);
        media.flowLayoutHeight = size.height;
    }
    
    return CGSizeMake(self.collectionView.bounds.size.width, media.flowLayoutHeight);
}


@end
