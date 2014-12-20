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

- (IBAction)didVideoButtonClicked:(id)sender
{
}

@end
