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

@interface ELCAssetsCollectionViewController : UICollectionViewController < ELCAssetDelegate >
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSArray *elcAssets;
@end
