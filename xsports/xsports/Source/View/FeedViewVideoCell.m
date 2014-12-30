//
//  FeedViewVideoCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewVideoCell.h"

static void *AVPlayerItemStatusObservationContext = &AVPlayerItemStatusObservationContext;
static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;
static void *AVPlayerLayerReadyForDisplayObservationContext = &AVPlayerLayerReadyForDisplayObservationContext;

@interface FeedViewVideoCell ()
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) AVPlayer *player;
@property (strong, nonatomic) id playerTimeObserver;
@property (assign, nonatomic) VideoStatus status;
@end

@implementation FeedViewVideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.playerView.layer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerLayerReadyForDisplayObservationContext];
}

- (void)dealloc
{
    [self.playerView.layer removeObserver:self forKeyPath:@"readyForDisplay"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVPlayerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem == self.playerItem) {
            if (self.window) {
                [self startPlaying];
            }
        }
    } else if (context == AVPlayerLayerReadyForDisplayObservationContext) {
        if (!((AVPlayerLayer *)self.playerView.layer).readyForDisplay) {
            self.playerView.alpha = 0;
        }
    } else if (context == AVPlayerItemStatusObservationContext) {
        if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
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
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setStatus:(VideoStatus)status
{
    _status = status;
    switch (status) {
        case kVideoStatusLoading:
        {
            [self.videoButton.layer removeAllAnimations];
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_loading"] forState:UIControlStateNormal];
            self.videoButton.alpha = 1.0;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                self.videoButton.alpha = 0;
            } completion:nil];
        }
            break;
        case kVideoStatusPause:
        {
            [self.videoButton.layer removeAllAnimations];
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_play"] forState:UIControlStateNormal];
            self.videoButton.alpha = 1.0;
        }
            break;
        case kVideoStatusPlaying:
        {
            [self.videoButton.layer removeAllAnimations];
            [self.videoButton setBackgroundImage:[UIImage imageNamed:@"ico_video_pause"] forState:UIControlStateNormal];
            self.videoButton.alpha = 1.0;
            [UIView animateWithDuration:1.0 animations:^{
                self.videoButton.alpha = 0;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)start
{
    if ([AVPlayerManager sharedInstance].currentPlayingItem == self) {
        return;
    }
    
    [[AVPlayerManager sharedInstance].currentPlayingItem stop];
    [AVPlayerManager sharedInstance].currentPlayingItem = self;
    
    NSAssert(self.playerItem == nil, @"Player Item should be nil when start");
    NSAssert(self.player == nil, @"Player should be nil when start");
    
    self.playerView.alpha = 0;
    self.status = kVideoStatusLoading;
    
    AVPlayer *player = [[AVPlayerManager sharedInstance] borrowAVPlayer];
    self.player = player;
    [self.playerView setPlayer:self.player];
    [self.player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerCurrentItemObservationContext];
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.media.videos.standard.url]];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerItemStatusObservationContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.playerTimeObserver = [self.player addBoundaryTimeObserverForTimes:@[[NSValue valueWithCMTime:CMTimeMakeWithSeconds(0.1, 10)]] queue:nil usingBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.playerView.alpha = 1.0;
        }];
    }];
}

- (void)stop
{
    if ([AVPlayerManager sharedInstance].currentPlayingItem == self) {
        [AVPlayerManager sharedInstance].currentPlayingItem = nil;
    }
    
    NSAssert(self.player != nil, @"Player should not be empty");
    NSAssert(self.playerItem != nil, @"Player Item should not be empty");
    [self stopPlaying];
    self.playerView.alpha = 0;
    [self.player removeObserver:self forKeyPath:@"currentItem"];
    [self.player removeTimeObserver:self.playerTimeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView setPlayer:nil];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [[AVPlayerManager sharedInstance] returnAVPlayer:self.player];
    self.player = nil;
    self.playerItem = nil;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
    [UIView animateWithDuration:0.25 animations:^{
        self.playerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.playerView.alpha = 0.0;
    }];
}

- (void)startPlaying
{
    [self.player play];
    self.status = kVideoStatusPlaying;
}

- (void)stopPlaying
{
    [self.player pause];
    self.status = kVideoStatusPause;
}

- (IBAction)didVideoButtonClicked:(id)sender
{
    if ([AVPlayerManager sharedInstance].currentPlayingItem == self) {
        if (self.player.rate > 0) {
            [self stopPlaying];
        } else {
            [self startPlaying];
        }
    } else {
        [self start];
    }
}

@end
