//
//  ELCAssetsCollector.h
//  xsports
//
//  Created by Shengzhe Chen on 1/11/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELCAsset.h"

typedef enum : NSUInteger {
    kAssetsPickerModePhoto,
    kAssetsPickerModeVideo
} kAssetsPickerMode;

@interface ELCAssetsCollector : NSObject
@property (assign, nonatomic) kAssetsPickerMode mode;
@property (strong, nonatomic, readonly) NSMutableArray *assetGroups;
@property (strong, nonatomic, readonly) NSMutableDictionary *assetsGroupAssets;
@property (assign, nonatomic) BOOL isReady;
+ (ELCAssetsCollector *)sharedInstance;
- (void)loadAssetsGroup;
- (BOOL)isAuthorized;
@end
