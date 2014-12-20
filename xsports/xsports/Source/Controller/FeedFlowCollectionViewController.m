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

static void *AVPlayerItemStatusObservationContext = &AVPlayerItemStatusObservationContext;
static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;

@interface FeedFlowCollectionViewController () < UICollectionViewDelegateFlowLayout >
@property (strong, nonatomic) NSDictionary *prototypes;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) FeedViewVideoCell *playerVideoCell;
@end

@implementation FeedFlowCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPlayer];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewVideoCellIdentifier];
    [self preparePrototypes];
}

- (void)setupPlayer
{
    self.player = [[AVPlayer alloc] init];
    [self.player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerCurrentItemObservationContext];
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

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
}

- (void)attachPlayer:(AVPlayer *)player toVideoCell:(FeedViewVideoCell *)cell withMedia:(Media *)media
{
    [self detachPlayer:player fromVideoCell:self.playerVideoCell];
    self.playerVideoCell = cell;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:media.videos.standard.url]];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerItemStatusObservationContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)detachPlayer:(AVPlayer *)player fromVideoCell:(FeedViewVideoCell *)cell
{
    if (self.playerVideoCell == cell) {
        [player seekToTime:kCMTimeZero];
        [cell.playerView setPlayer:nil];
        [self.playerVideoCell.playerView setPlayer:nil];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.playerItem = nil;
        self.playerVideoCell = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVPlayerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem == self.playerItem) {
            if (self.playerVideoCell.window) {
                [self.playerVideoCell.playerView setPlayer:self.player];
                [self.player play];
            }
        }
    } else if (context == AVPlayerItemStatusObservationContext) {
        if (object == self.playerItem) {
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                case AVPlayerItemStatusUnknown:
                case AVPlayerItemStatusReadyToPlay:
                {
                    if (self.player.currentItem != self.playerItem) {
                        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
        [self attachPlayer:self.player toVideoCell:(FeedViewVideoCell *)cell withMedia:media];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    if ([media isVideo]) {
        [self detachPlayer:self.player fromVideoCell:(FeedViewVideoCell *)cell];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
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
