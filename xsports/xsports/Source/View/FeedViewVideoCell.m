//
//  FeedViewVideoCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewVideoCell.h"

@interface FeedViewVideoCell () < MediaDelegate >

@end

@implementation FeedViewVideoCell

- (IBAction)didVideoButtonClicked:(id)sender
{
    if (![self.media isVideo]) {
        return;
    }
    
    if (self.media.player.rate > 0) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)setMedia:(Media *)media
{
    self.media.delegate = nil;
    [super setMedia:media];
    media.delegate = self;
    [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
}

- (void)play
{
    if (!self.media.playerItem) {
        [self.media loadPlayerItem];
        return;
    }
    [self.playerView setPlayer:self.media.player];
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_pause"] forState:UIControlStateNormal];
}

- (void)pause
{
    [self.media.player pause];
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_play"] forState:UIControlStateNormal];
}

#pragma mark MediaDelegate
- (void)media:(Media *)media didPlayItemEndPlay:(AVPlayerItem *)playerItem
{
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_play"] forState:UIControlStateNormal];
}

- (void)media:(Media *)media didPlayItemFailoPlay:(AVPlayerItem *)playerItem
{
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_refresh"] forState:UIControlStateNormal];
}

- (void)media:(Media *)media didPlayItemReadyToPlay:(AVPlayerItem *)playerItem
{
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_play"] forState:UIControlStateNormal];
    [self play];
}

@end
