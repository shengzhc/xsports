//
//  FeedGridCollectionViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/17/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedGridCollectionViewController.h"
#import "FeedViewGridPhotoCell.h"
#import "FeedViewGridVideoCell.h"

@interface FeedGridCollectionViewController ()
@property (strong, nonatomic) NSDictionary *prototypes;
@end

@implementation FeedGridCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewGridPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewGridVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewGridVideoCellIdentifier];
    [self preparePrototypes];
}

- (void)preparePrototypes
{
    NSMutableDictionary *prototypes = [NSMutableDictionary new];
    id cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedViewGridPhotoCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[FeedViewPhotoCellIdentifier] = cell;
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedViewGridVideoCell" owner:nil options:nil] objectAtIndex:0];
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
    if ([media  isVideo]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewGridVideoCellIdentifier forIndexPath:indexPath];
        ((FeedViewGridVideoCell *)cell).media = media;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier forIndexPath:indexPath];
        ((FeedViewGridPhotoCell *)cell).media = media;
    }
    
    return cell;
}

@end
