//
//  FeedViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedViewPhotoCell.h"

@interface FeedViewController () < UICollectionViewDelegate, UICollectionViewDataSource >
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSArray *feeds;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.flowLayout.itemSize.width != self.collectionView.bounds.size.width) {
        self.flowLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width, 500.0);
        [self.flowLayout invalidateLayout];
    }
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedViewPhotoCellIdentifier forIndexPath:indexPath];
    
    ((FeedViewPhotoCell *)cell).media = self.feeds[indexPath.item];
    return cell;
}

@end
