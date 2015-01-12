//
//  ELCAssetsCollector.m
//  xsports
//
//  Created by Shengzhe Chen on 1/11/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "ELCAssetsCollector.h"

@interface ELCAssetsCollector ()
@property (strong, nonatomic) ALAssetsLibrary *library;
@end

@implementation ELCAssetsCollector

+ (ELCAssetsCollector *)sharedInstance
{
    static ELCAssetsCollector *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ELCAssetsCollector alloc] init];
        [sharedInstance loadAssetsGroup];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.library = [[ALAssetsLibrary alloc] init];
        _assetsGroupAssets = [NSMutableDictionary new];
        _assetGroups = [NSMutableArray new];
    }
    
    return self;
}

- (ALAssetsFilter *)assetFilter
{
    if (self.mode == kAssetsPickerModePhoto) {
        return [ALAssetsFilter allPhotos];
    } else {
        return [ALAssetsFilter allVideos];
    }
}

- (BOOL)isAuthorized
{
    return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized;
}

- (void)setMode:(kAssetsPickerMode)mode
{
    _mode = mode;
    self.isReady = NO;
    if (_assetGroups) {
        for (ALAssetsGroup *group in _assetGroups) {
            [group setAssetsFilter:[self assetFilter]];
        }
    }
    self.isReady = YES;
    [self loadAllAssets];
}

#pragma mark Load Assets
- (void)loadAssetsGroup
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group == nil) {
                    self.isReady = YES;
                    return;
                }
                [group setAssetsFilter:[self assetFilter]];
                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                    [_assetGroups insertObject:group atIndex:0];
                } else {
                    [_assetGroups addObject:group];
                }
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

- (void)loadAllAssets
{
    for (ALAssetsGroup *group in _assetGroups) {
        [self loadAssetsForAssetGroup:group];
    }
}

- (void)loadAssetsForAssetGroup:(ALAssetsGroup *)assetsGroup
{
    @autoreleasepool {
        [_assetsGroupAssets removeObjectForKey:@(assetsGroup.hash)];
        __block NSMutableArray *elcAssets = [NSMutableArray new];
        [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                return;
            }
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAssets addObject:elcAsset];
        }];
        _assetsGroupAssets[@(assetsGroup.hash)] = elcAssets;
    }
}

@end
