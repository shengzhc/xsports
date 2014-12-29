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

- (void)prepareAsset:(AVAsset *)asset requestedKeys:(NSArray *)requestedKeys
{
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        self.playerItem = nil;
    }
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerItemStatusObservationContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    if (!self.player) {
        [self setPlayer:[[AVPlayerManager sharedInstance] availableAVPlayer]];
        [self.player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerCurrentItemObservationContext];
    }
    
    if (self.player.currentItem != self.self.playerItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
}

- (void)start
{
    if ([[AVPlayerManager sharedInstance] currentPlayingItem] != self) {
        [[[AVPlayerManager sharedInstance] currentPlayingItem] stop];

        NSArray *requestedKeys = @[@"playable"];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.media.videos.standard.url] options:nil];
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareAsset:asset requestedKeys:requestedKeys];
            });
        }];
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
        if (self.player) {
            [self.player removeObserver:self forKeyPath:@"currentItem"];
            self.player = nil;
            [UIView animateWithDuration:0.25 animations:^{
                self.playerView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.playerView.alpha = 1.0;
                [self.playerView setPlayer:nil];
            }];
        }
    }
}

- (IBAction)didVideoButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(feedViewVideoCell:didVideoButtonClicked:)]) {
        [self.delegate feedViewVideoCell:self didVideoButtonClicked:sender];
    }
}

@end
