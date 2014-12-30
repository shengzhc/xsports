//
//  FeedViewVideoCell.h
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewPhotoCell.h"
#import "AVPlayerView.h"

typedef enum : NSUInteger {
    kVideoStatusPause,
    kVideoStatusLoading,
    kVideoStatusPlaying
} VideoStatus;

@interface FeedViewVideoCell : FeedViewPhotoCell < AVPlayerPresentationItemProtocol >
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet AVPlayerView *playerView;

- (IBAction)didVideoButtonClicked:(id)sender;
@end
