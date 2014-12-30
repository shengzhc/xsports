//
//  AVPlayerManager.m
//  xsports
//
//  Created by Shengzhe Chen on 12/28/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "AVPlayerManager.h"
#import "AVPlayerView.h"

#define MAX_PLAYERS 2

@interface AVPlayerManager ()
@property (strong, nonatomic) NSMutableArray *pendingPlayers;
@property (strong, nonatomic) NSMutableArray *activePlayers;
@end

@implementation AVPlayerManager

+ (AVPlayerManager *)sharedInstance
{
    static AVPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AVPlayerManager alloc] init];
    });
    return manager;
}

- (id)init
{
    if (self = [super init]) {
        self.pendingPlayers = [NSMutableArray new];
        self.activePlayers = [NSMutableArray new];
        for (NSUInteger i=0; i<MAX_PLAYERS; i++) {
            [self.pendingPlayers addObject:[[AVPlayer alloc] init]];
        }
    }
    return self;
}

- (AVPlayer *)borrowAVPlayer
{
    if (self.pendingPlayers.count > 0) {
        AVPlayer *player = [self.pendingPlayers firstObject];
        [self.pendingPlayers removeObject:player];
        [self.activePlayers addObject:player];
        return player;
    } else {
        AVPlayer *player = [[AVPlayer alloc] init];
        [self.activePlayers addObject:player];
        return player;
    }
}

- (void)returnAVPlayer:(AVPlayer *)player
{
    if ([self.activePlayers containsObject:player]) {
        [self.activePlayers removeObject:player];
        [self.pendingPlayers addObject:player];
    }
}

@end
