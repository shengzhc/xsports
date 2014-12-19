//
//  FeedViewVideoCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewVideoCell.h"

typedef enum : NSUInteger {
    kVideoStatusUnload,
    kVideoStatusLoading,
    kVideoStatusPlaying,
    kVideoStatusPause
} VideoStatus;

static void *AVPlayerItemStatusObservationContext = &AVPlayerItemStatusObservationContext;
static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;

@interface FeedViewVideoCell ()
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (assign, nonatomic) VideoStatus status;
@property (assign, nonatomic) BOOL isVideoReady;
@end

@implementation FeedViewVideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    self.player = [[AVPlayer alloc] init];
    [self.player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerCurrentItemObservationContext];
}

- (void)dealloc
{
    [self.player removeObserver:self forKeyPath:@"currentItem"];
}

- (void)setMedia:(Media *)media
{
    [super setMedia:media];
    self.status = kVideoStatusUnload;
}

- (void)setStatus:(VideoStatus)status
{
    _status = status;
    switch (status) {
        case kVideoStatusUnload:
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_play"] forState:UIControlStateNormal];
            break;
        case kVideoStatusLoading:
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_loading"] forState:UIControlStateNormal];
            break;
        case kVideoStatusPause:
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_play"] forState:UIControlStateNormal];
            break;
        case kVideoStatusPlaying:
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_pause"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)play
{
    switch (self.status) {
        case kVideoStatusUnload:
        {
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.media.videos.standard.url]];
            if (self.playerItem) {
                self.status = kVideoStatusLoading;
                [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerItemStatusObservationContext];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
            }
        }
            break;
        case kVideoStatusPause:
        {
            if (self.player && self.player.currentItem) {
                [self.player play];
                self.status = kVideoStatusPlaying;
            }
        }
            break;
        default:
            break;
    }
}

- (void)pause
{
    if (self.player && self.player.rate > 0) {
        [self.player pause];
        self.status = kVideoStatusPause;
    }
}

- (void)clear
{
    [self pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.playerItem = nil;
    [self.playerView setPlayer:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
    self.status = kVideoStatusPause;
}

- (IBAction)didVideoButtonClicked:(id)sender
{
    switch (self.status) {
        case kVideoStatusPlaying:
        {
            [self pause];
        }
            break;
        case kVideoStatusPause:
        {
            [self play];
        }
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVPlayerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem == self.playerItem) {
            self.status = kVideoStatusPause;
            [self.playerView setPlayer:self.player];
            [self play];
        }
    } else if (context == AVPlayerItemStatusObservationContext) {
        if (object == self.playerItem) {
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                case AVPlayerItemStatusUnknown:
                case AVPlayerItemStatusReadyToPlay:
                {
                    if (self.player.currentItem != self.playerItem) {
                        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



@end
