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

@class FeedViewVideoCell;
@protocol FeedViewVideoCellDelegate <NSObject>
@optional
- (void)feedViewVideoCell:(FeedViewVideoCell *)cell didVideoButtonClicked:(id)sender;
@end

@interface FeedViewVideoCell : FeedViewPhotoCell
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet AVPlayerView *playerView;
@property (weak, nonatomic) id <FeedViewVideoCellDelegate, FeedViewPhotoCellDelegate> delegate;

- (void)syncWithStatus:(VideoStatus)status;
- (IBAction)didVideoButtonClicked:(id)sender;
@end
