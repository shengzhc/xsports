//
//  FeedViewVideoCell.m
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewVideoCell.h"

@interface FeedViewVideoCell ()
@end

@implementation FeedViewVideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
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

- (IBAction)didVideoButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(feedViewVideoCell:didVideoButtonClicked:)]) {
        [self.delegate feedViewVideoCell:self didVideoButtonClicked:sender];
    }
}

@end
