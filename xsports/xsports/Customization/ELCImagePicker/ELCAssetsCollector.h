//
//  ELCAssetsCollector.h
//  xsports
//
//  Created by Shengzhe Chen on 1/11/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELCAsset.h"

@interface ELCAssetsCollector : NSObject
@property (strong, nonatomic) NSArray *mediaTypes;
@property (strong, nonatomic, readonly) NSMutableArray *assetGroups;
@property (strong, nonatomic, readonly) NSMutableDictionary *assetsGroupAssets;
@property (assign, nonatomic) BOOL isReady;
+ (ELCAssetsCollector *)picCollector;
+ (ELCAssetsCollector *)videoCollector;
- (void)loadAssetsGroup;
- (BOOL)isAuthorized;
@end
