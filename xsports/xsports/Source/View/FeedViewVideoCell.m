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

@interface FeedViewVideoCell ()
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) AVPlayer *player;
@end

@implementation FeedViewVideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
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
    } else if (context == AVPlayerItemStatusObservationContext) {
        if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                case AVPlayerItemStatusUnknown:
                case AVPlayerItemStatusReadyToPlay:
                {
                    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
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

- (void)setPlayer:(AVPlayer *)player
{
    if (_player) {
        [_player pause];
        [_player removeObserver:self forKeyPath:@"currentItem"];
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
    
    _player = player;
    if (_player) {
        [self.playerView setPlayer:_player];
        [_player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerCurrentItemObservationContext];
    }
}

- (void)syncWithStatus:(VideoStatus)status
{
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

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if (self.player) {
        [self.player seekToTime:kCMTimeZero];
    }
}

- (void)startPlaying
{
    [self.player play];
    if (self.player.currentTime.value == 0) {
        self.playerView.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            self.playerView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.playerView.alpha = 1.0;
        }];
    }
}

- (void)stopPlaying
{
    [self.player pause];
}

- (void)start
{
    if ([[AVPlayerManager sharedInstance] currentPlayingItem] != self) {
        [[[AVPlayerManager sharedInstance] currentPlayingItem] stop];
        [self setPlayer:[[AVPlayerManager sharedInstance] availableAVPlayer]];
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.media.videos.standard.url]];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerItemStatusObservationContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        [[AVPlayerManager sharedInstance] setCurrentPlayingItem:self];
    }
}

- (void)stop
{
    if ([[AVPlayerManager sharedInstance] currentPlayingItem] == self) {
        if (self.playerItem) {
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            self.playerItem = nil;
        }

        [[AVPlayerManager sharedInstance] setCurrentPlayingItem:nil];
        [UIView animateWithDuration:0.25 animations:^{
            self.playerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self setPlayer:nil];
            self.playerView.alpha = 1.0;
        }];
    }
}

- (IBAction)didVideoButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(feedViewVideoCell:didVideoButtonClicked:)]) {
        [self.delegate feedViewVideoCell:self didVideoButtonClicked:sender];
    }
}

- (AVAsset*)makeAssetComposition
{
    int numOfCopies = 1;

    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    AVURLAsset* sourceAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.media.videos.standard.url] options:nil];
    // calculate time
    CMTimeRange editRange = CMTimeRangeMake(CMTimeMake(0, 600), CMTimeMake(sourceAsset.duration.value, sourceAsset.duration.timescale));
    
    NSError *editError;
    
    // and add into your composition
    BOOL result = [composition insertTimeRange:editRange ofAsset:sourceAsset atTime:composition.duration error:&editError];
    
    if (result) {
        for (int i = 0; i < numOfCopies; i++) {
            [composition insertTimeRange:editRange ofAsset:sourceAsset atTime:composition.duration error:&editError];
        }
    }
    
    return composition;
}

@end
