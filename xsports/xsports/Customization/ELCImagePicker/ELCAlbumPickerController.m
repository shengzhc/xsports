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
    [self load];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableView];
}

- (ALAssetsFilter *)assetFilter
{
    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie]) {
        return [ALAssetsFilter allAssets];
    } else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie]) {
        return [ALAssetsFilter allVideos];
    } else {
        return [ALAssetsFilter allPhotos];
    }
}

- (ELCAssetsCollectionViewController *)assetsCollectionViewController
{
    if (!_assetsCollectionViewController) {
        _assetsCollectionViewController = [[UIStoryboard storyboardWithName:@"Cam" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:ELCAssetsCollectionViewControllerIdentifier];
        [_assetsCollectionViewController view];
    }
    return _assetsCollectionViewController;
}

- (void)load
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.assetGroups = tempArray;
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group == nil) {
                    return;
                }
                [group setAssetsFilter:[self assetFilter]];
                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                    [self.assetGroups insertObject:group atIndex:0];
                } else {
                    [self.assetGroups addObject:group];
                }
                [self reloadTableView];
                self.assetsCollectionViewController.assetGroup = self.assetGroups.firstObject;
            };
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                    NSString *errorMessage = NSLocalizedString(@"This app does not have access to your photos or videos. You can enable access in Privacy Settings.", nil);
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                } else {
                    NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                }
            };
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
        }
    });
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

