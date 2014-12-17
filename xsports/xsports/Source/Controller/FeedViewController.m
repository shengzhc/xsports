//
//  FeedViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedViewPhotoCell.h"
#import "FeedViewVideoCell.h"
#import "FeedViewGridPhotoCell.h"

@interface FeedViewController () < UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSArray *feeds;
@property (strong, nonatomic) NSDictionary *prototypes;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewVideoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewGridPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier];
    [self preparePrototypes];
    [self load];
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

- (void)load
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"instagram" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *medias = json[@"data"];
    NSMutableArray *feeds = [NSMutableArray new];
    for (NSDictionary *media in medias) {
        [feeds addObject:[[Media alloc] initWithDictionary:media error:nil]];
    }
    self.feeds = feeds;
    [self.collectionView reloadData];
}

#pragma mark Action
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.feeds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Media *media = self.feeds[indexPath.item];
    UICollectionViewCell *cell = nil;
//    if ([media isVideo]) {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewVideoCellIdentifier forIndexPath:indexPath];
//        ((FeedViewVideoCell *)cell).media = self.feeds[indexPath.item];
//
//    } else {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewPhotoCellIdentifier forIndexPath:indexPath];
//        ((FeedViewPhotoCell *)cell).media = self.feeds[indexPath.item];
//    }
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier forIndexPath:indexPath];
    ((FeedViewGridPhotoCell *)cell).media = media;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Media *media = self.feeds[indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Media *media = self.feeds[indexPath.item];
//    FeedViewPhotoCell *cell = nil;
//    if ([media isVideo]) {
//        cell = self.prototypes[FeedViewVideoCellIdentifier];
//    } else {
//        cell = self.prototypes[FeedViewPhotoCellIdentifier];
//    }
//    cell.frame = CGRectMake(0, 0, collectionView.bounds.size.width, 10000);
//    cell.media = self.feeds[indexPath.item];
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
//    CGSize size = CGSizeMake(collectionView.bounds.size.width, cell.bottomContainer.frame.origin.y + cell.bottomContainer.frame.size.height);
//    size.width = ceilf(size.width);
//    size.height = ceilf(size.height);
    CGFloat width = collectionView.bounds.size.width / 3.0;
    if (indexPath.item % 3 == 0) {
        return CGSizeMake(width * 2, width * 2);
    }
    return CGSizeMake(width-5, width-5);
//    return size;
}

@end
