//
//  FeedFlowCollectionViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/17/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedFlowCollectionViewController.h"
#import "LikesViewController.h"
#import "CommentsViewController.h"
#import "FeedViewPhotoCell.h"
#import "FeedViewVideoCell.h"


@interface FeedFlowCollectionViewController () < UICollectionViewDelegateFlowLayout, FeedViewVideoCellDelegate, FeedViewPhotoCellDelegate, UIScrollViewDelegate >
{
    NSIndexPath *_lastVideoIndexPath;
    CGPoint _lastContentOffset;
}
@property (strong, nonatomic) NSDictionary *prototypes;
@end

@implementation FeedFlowCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
}

#pragma mark Setup
- (void)setupCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewVideoCellIdentifier];
    [self preparePrototypes];
}

- (void)setFeeds:(NSArray *)feeds
{
    _feeds = feeds;
    [self.collectionView reloadData];
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

#pragma mark FeedViewVideoCellDelegate
- (void)feedViewVideoCell:(FeedViewVideoCell *)cell didVideoButtonClicked:(id)sender
{

}

- (void)feedViewPhotoCell:(FeedViewPhotoCell *)cell didLikeAmountButtonClicked:(id)sender
{
    LikesViewController *likesViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:LikesViewControllerIdentifier];
    likesViewController.mediaId = cell.media.mid;
    [self.navigationController pushViewController:likesViewController animated:YES];
}

- (void)feedViewPhotoCell:(FeedViewPhotoCell *)cell didCommentButtonClicked:(id)sender
{
    CommentsViewController *commentsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:CommentsViewControllerIdentifier];
    commentsViewController.mediaId = cell.media.mid;
    [self.navigationController pushViewController:commentsViewController animated:YES];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSMutableArray *validCells = [NSMutableArray new];
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:[FeedViewVideoCell class]]) {
            CGRect frame = [self.collectionView convertRect:((FeedViewVideoCell *)cell).playerView.frame fromView:cell];
            if (CGRectIntersection(frame, visibleRect).size.height >= frame.size.height * 0.25) {
                [validCells addObject:cell];
            }
        }
    }
    BOOL isUp = (self.collectionView.contentOffset.y - _lastContentOffset.y) > 0;
    _lastContentOffset = self.collectionView.contentOffset;
    
    if (validCells.count > 0) {
        FeedViewVideoCell *nextCell = isUp ? validCells.lastObject : validCells.firstObject;
        if (_lastVideoIndexPath.item != [self.collectionView indexPathForCell:nextCell].item) {
            _lastVideoIndexPath = [self.collectionView indexPathForCell:nextCell];
            [nextCell start];
        }
    } else {
        if (_lastVideoIndexPath != nil) {
            FeedViewVideoCell *nextCell = (FeedViewVideoCell *)[self.collectionView cellForItemAtIndexPath:_lastVideoIndexPath];
            [nextCell stop];
            _lastVideoIndexPath = nil;
        }
    }
}

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
        ((FeedViewVideoCell *)cell).delegate = self;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewPhotoCellIdentifier forIndexPath:indexPath];
        ((FeedViewPhotoCell *)cell).media = self.feeds[indexPath.item];
        ((FeedViewPhotoCell *)cell).delegate = self;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    if ([media isVideo]) {

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
