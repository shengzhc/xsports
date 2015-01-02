//
//  ELCAssetsCollectionViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"

@interface ELCAssetsCollectionViewController : UICollectionViewController < ELCAssetDelegate >

@property (nonatomic, weak) id <ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, assign) BOOL singleSelection;
@property (nonatomic, assign) BOOL immediateReturn;
@property(nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

- (NSUInteger)totalSelectedAssets;
- (void)preparePhotos;

@end
