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

+ (ELCAssetsCollector *)picCollector
{
    static ELCAssetsCollector *picCollector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picCollector = [[ELCAssetsCollector alloc] init];
        picCollector.mediaTypes = @[];
        [picCollector loadAssetsGroup];
    });
    
    return picCollector;
}

+ (ELCAssetsCollector *)videoCollector
{
    static ELCAssetsCollector *videoCollector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoCollector = [[ELCAssetsCollector alloc] init];
        videoCollector.mediaTypes = @[(NSString *)kUTTypeMovie];
        [videoCollector loadAssetsGroup];
    });
    
    return videoCollector;
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
    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie]) {
        return [ALAssetsFilter allAssets];
    } else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie]) {
        return [ALAssetsFilter allVideos];
    } else {
        return [ALAssetsFilter allPhotos];
    }
}

- (BOOL)isAuthorized
{
    return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized;
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
                [self loadAssetsForAssetGroup:group];
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

- (void)loadAssetsForAssetGroup:(ALAssetsGroup *)assetsGroup
{
    @autoreleasepool {
        [self.assetsGroupAssets removeObjectForKey:@(assetsGroup.hash)];
        __block NSMutableArray *elcAssets = [NSMutableArray new];
        [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                return;
            }
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAssets addObject:elcAsset];
        }];
        self.assetsGroupAssets[@(assetsGroup.hash)] = elcAssets;
    }
}

@end
