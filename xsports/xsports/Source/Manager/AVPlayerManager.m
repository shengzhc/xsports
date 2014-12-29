//
//  AVPlayerManager.m
//  xsports
//
//  Created by Shengzhe Chen on 12/28/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "AVPlayerManager.h"
#import "AVPlayerView.h"

@interface AVPlayerManager ()
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) AVPlayer *currentPlayer;
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
        AVPlayer *player1 = [[AVPlayer alloc] init];
        AVPlayer *player2 = [[AVPlayer alloc] init];
        self.players = @[player1, player2];
        self.currentPlayer = nil;
    }
    return self;
}

- (AVPlayer *)availableAVPlayer
{
    id player = nil;
    for (AVPlayer *item in self.players) {
        if (item != self.currentPlayer) {
            player = item;
        }
    }
    self.currentPlayer = player;
    return player;
}

@end
