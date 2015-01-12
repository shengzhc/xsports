//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "ELCAlbumPickerController.h"
#import "ELCAlbumCell.h"

@interface ELCAlbumPickerController ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation ELCAlbumPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableView];
}

- (ELCAssetsCollectionViewController *)assetsCollectionViewController
{
    if (!_assetsCollectionViewController) {
        _assetsCollectionViewController = [[UIStoryboard storyboardWithName:@"Cam" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:ELCAssetsCollectionViewControllerIdentifier];
        [_assetsCollectionViewController view];
    }
    return _assetsCollectionViewController;
}

- (void)reloadTableView
{
	[self.tableView reloadData];
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELCAlbumCell *cell = (ELCAlbumCell *)[tableView dequeueReusableCellWithIdentifier:ELCAlbumCellIdentifier forIndexPath:indexPath];
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
    cell.albumImageView.image = [self resize:image to:CGSizeMake(36, 36)];
    cell.albumTitleLabel.text = [g valueForProperty:ALAssetsGroupPropertyName];
    cell.assetsCountLabel.text = [NSString stringWithFormat:@"%@ \u27AD", @([g numberOfAssets])];
    return cell;
}

- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = self.assetGroups[indexPath.row];
    self.assetsCollectionViewController.assetGroup = group;
    [self.navigationController pushViewController:self.assetsCollectionViewController animated:YES];
}

@end

