//
//  VideoController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/16/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "VideoController.h"

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

const NSUInteger maxPlayerCount = 5;

@interface VideoController ()
@property (strong, nonatomic) NSMutableDictionary *playItems;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) AVPlayer *activePlayer;
@end

@implementation VideoController

- (void)loadPlayerItemAtURL:(NSURL *)url
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];

    NSArray *requestedKeys = @[@"playable"];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^
    {
         dispatch_async(dispatch_get_main_queue(),^{
             [self prepareToPlayAsset:asset withKeys:requestedKeys];
         });
    }];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    
}


- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            [self loadPlayerItemAtURL:asset.URL];
            return;
        }
    }
    
    if (!asset.playable) {
        return;
    }
    
    AVPlayerItem *mPlayerItem = self.playItems[asset.URL];
    if (!mPlayerItem) {
        mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
        self.playItems[asset.URL] = mPlayerItem;
        [mPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:mPlayerItem];

        if (self.players.count < maxPlayerCount) {
            AVPlayer *player = [AVPlayer playerWithPlayerItem:mPlayerItem];
            [player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
            [player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
            [self.players insertObject:player atIndex:0];
        } else {
            AVPlayer *player = [self.players lastObject];
            [self.players removeObject:player];
            [player replaceCurrentItemWithPlayerItem:mPlayerItem];
            [self.players insertObject:player atIndex:0];
        }
    }
}

- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status != AVPlayerItemStatusReadyToPlay) {
            AVPlayerItem *playerItem = (AVPlayerItem *)object;
            if ([playerItem.asset isKindOfClass:[AVURLAsset class]]) {
                [self.playItems removeObjectForKey:((AVURLAsset *)playerItem.asset).URL];
            }
        }
    } else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext) {
    
    } else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem == (id)[NSNull null]) {
        } else {
            /* Set the AVPlayer for which the player layer displays visual output. */
//            [self.mPlaybackView setPlayer:mPlayer];
//            
//            [self setViewDisplayName];
//            
//            /* Specifies that the player should preserve the video’s aspect ratio and
//             fit the video within the layer’s bounds. */
//            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
//            
//            [self syncPlayPauseButtons];
        }
    } else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

@end
