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
#import "FeedViewGridVideoCell.h"

#import "GridLayout.h"

@interface FeedViewController () < UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *layoutBarButtonItem;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) GridLayout *gridLayout;

@property (strong, nonatomic) NSArray *feeds;
@property (strong, nonatomic) NSDictionary *prototypes;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
    [self load];
}

- (void)preparePrototypes
{
    NSMutableDictionary *prototypes = [NSMutableDictionary new];
    id cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedViewPhotoCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[FeedViewPhotoCellIdentifier] = cell;
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedViewVideoCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[FeedViewVideoCellIdentifier] = cell;
    
    cell = [[NSBundle mainBundle] loadNibNamed:@"FeedViewGridPhotoCell" owner:nil options:0];
    prototypes[FeedViewGridPhotoCellIdentifier] = cell;
    
    cell = [[NSBundle mainBundle] loadNibNamed:@"FeedViewGridVideoCell" owner:nil options:0];
    prototypes[FeedViewGridVideoCellIdentifier] = cell;
    
    self.prototypes = prototypes;
}

- (void)setupGridLayout
{
    self.gridLayout = [[GridLayout alloc] init];
}

- (void)setupCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewVideoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewGridPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedViewGridVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FeedViewGridVideoCellIdentifier];
    [self setupGridLayout];
    [self preparePrototypes];
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

- (IBAction)didLayoutBarButtonItemClicked:(id)sender
{
    if (self.collectionView.collectionViewLayout == self.flowLayout) {
//        self.collectionView.collectionViewLayout = self.gridLayout;
        [self.collectionView setCollectionViewLayout:self.gridLayout animated:YES];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self.collectionView.collectionViewLayout invalidateLayout];
//        [self.collectionView reloadData];
        [self.layoutBarButtonItem setImage:[UIImage imageNamed:@"ico_layout_list"]];
    } else {
//        self.collectionView.collectionViewLayout = self.flowLayout;
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self.collectionView.collectionViewLayout invalidateLayout];
//        [self.collectionView.collectionViewLayout invalidateLayout];
//        [self.collectionView reloadData];
        [self.layoutBarButtonItem setImage:[UIImage imageNamed:@"ico_layout_grid"]];
    }
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
    
    if (self.collectionView.collectionViewLayout == self.flowLayout) {
        if ([media isVideo]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewVideoCellIdentifier forIndexPath:indexPath];
            ((FeedViewVideoCell *)cell).media = self.feeds[indexPath.item];
    
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewPhotoCellIdentifier forIndexPath:indexPath];
            ((FeedViewPhotoCell *)cell).media = self.feeds[indexPath.item];
        }
    } else if (self.collectionView.collectionViewLayout == self.gridLayout) {
        if ([media  isVideo]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier forIndexPath:indexPath];
            ((FeedViewGridVideoCell *)cell).media = media;
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewGridPhotoCellIdentifier forIndexPath:indexPath];
            ((FeedViewGridPhotoCell *)cell).media = media;
        }
    }
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Media *media = self.feeds[indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.collectionViewLayout == self.flowLayout) {
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
        
//        NSLog(@"%@", NSStringFromCGSize(size));
//        return CGSizeMake(self.collectionView.bounds.size.width, 680);

//        return size;
    }
    return CGSizeMake(self.collectionView.bounds.size.width, 680);
}

@end
