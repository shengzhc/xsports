//
//  Media.m
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "Media.h"
static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;


@implementation Caption

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"created_time": @"createdTime",
                                                       @"from": @"creator",
                                                       @"id": @"cid",
                                                       @"text": @"text"}];
}


@end

@implementation Comment

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"created_time": @"createdTime",
                                                       @"from": @"creator",
                                                       @"id": @"cid",
                                                       @"text": @"text"}];
}

@end

@implementation Image

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"height": @"height",
                                                       @"url": @"url",
                                                       @"width": @"width"}];
}

@end

@implementation Images

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"low_resolution": @"low",
                                                       @"standard_resolution": @"standard",
                                                       @"thumbnail": @"high"}];
}

@end

@implementation Video

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"height": @"height",
                                                       @"url": @"url",
                                                       @"width": @"width"}];
}

@end

@implementation Videos

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"low_bandwidth": @"low",
                                                       @"standard_resolution": @"standard",
                                                       @"low_resolution": @"high"}];
}



@end


@implementation Location

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"lid",
                                                       @"latitude": @"latitude",
                                                       @"longitude": @"longitude",
                                                       @"name": @"name"}];
}

@end

@implementation Media

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"attribution": @"attribution",
                                                       @"caption": @"caption",
                                                       @"comments.count": @"totalComments",
                                                       @"comments.data": @"comments",
                                                       @"created_time": @"createdTime",
                                                       @"filter": @"filter",
                                                       @"id": @"mid",
                                                       @"images": @"images",
                                                       @"videos": @"videos",
                                                       @"likes.count": @"totalLikes",
                                                       @"likes.data": @"likes",
                                                       @"link": @"link",
                                                       @"location": @"location",
                                                       @"type": @"type",
                                                       @"user": @"creator"}];
}

- (BOOL)isVideo
{
    if ([[self.type lowercaseString] isEqualToString:@"video"] && self.videos.standard) {
        return YES;
    }
    return NO;
}

- (void)loadPlayerItem
{
    if (self.playerItem) {
        return;
    }
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.videos.standard.url] options:nil];
    NSArray *requestedKeys = @[@"playable"];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self prepareToPlayAsset:asset withKeys:requestedKeys];
        });
    }];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            [self loadPlayerItem];
            return;
        }
    }
    
    if (!asset.playable) {
        return;
    }

    NSAssert(self.playerItem == nil, @"Should be empty");
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    NSLog(@"CHEN");

    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    [self.player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
//    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(media:didPlayItemEndPlay:)]) {
        [self.delegate media:self didPlayItemEndPlay:self.playerItem];
    }
}

- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
            case AVPlayerItemStatusFailed:
            {
                if ([self.delegate respondsToSelector:@selector(media:didPlayItemFailoPlay:)]) {
                    [self.delegate media:self didPlayItemFailoPlay:object];
                }
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                if ([self.delegate respondsToSelector:@selector(media:didPlayItemReadyToPlay:)]) {
                    [self.delegate media:self didPlayItemReadyToPlay:object];
                }
            }
                break;
            default:
                break;
        }
    } else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

@end
