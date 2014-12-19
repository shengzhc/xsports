//
//  FeedViewVideoCell.h
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewPhotoCell.h"
#import "AVPlayerView.h"

@interface FeedViewVideoCell : FeedViewPhotoCell
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet AVPlayerView *playerView;

- (void)play;
- (void)pause;
- (void)clear;
@end
