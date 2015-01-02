//
//  ELCAssetsCollectionViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "ELCAssetsCollectionViewController.h"
#import "ELCAssetsCollectionCell.h"

@interface ELCAssetsCollectionViewController () < UICollectionViewDelegateFlowLayout >
@property (weak, nonatomic) NSIndexPath *lastSelectedIndexPath;
@end

@implementation ELCAssetsCollectionViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparePhotos) name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)load
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)preparePhotos
{
    @autoreleasepool {
        [self.elcAssets removeAllObjects];
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                return;
            }
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [self.elcAssets addObject:elcAsset];
        }];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            NSInteger section = [self.collectionView numberOfSections] - 1;
            NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
            if (section >= 0 && item >= 0) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        });
    }
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.elcAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCAssetsCollectionCell *cell = (ELCAssetsCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ELCAssetsCollectionCellIdentifier forIndexPath:indexPath];
    cell.asset = self.elcAssets[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCAssetsCollectionCell *cell = (ELCAssetsCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ELCAsset *asset = (ELCAsset *)self.elcAssets[indexPath.item];
    asset.selected = !asset.selected;
    [cell setOverlayEnabled:asset.selected];
    
    if (asset.selected) {
        if (self.lastSelectedIndexPath && self.lastSelectedIndexPath.item != indexPath.item) {
            ((ELCAsset *)self.elcAssets[self.lastSelectedIndexPath.item]).selected = NO;
            [((ELCAssetsCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.lastSelectedIndexPath]) setOverlayEnabled:NO];
        }
        self.lastSelectedIndexPath = indexPath;
    } else {
        self.lastSelectedIndexPath = nil;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat length = floorf(collectionView.bounds.size.width/4.0);
    return CGSizeMake(length, length);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end