//
//  AVPlayerManager.h
//  xsports
//
//  Created by Shengzhe Chen on 12/28/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AVPlayerPresentationItemProtocol <NSObject>
@required
- (void)start;
- (void)stop;
@end

@interface AVPlayerManager : NSObject
@property (weak, nonatomic) id < AVPlayerPresentationItemProtocol > currentPlayingItem;
+ (AVPlayerManager *)sharedInstance;
- (AVPlayer *)borrowAVPlayer;
- (void)returnAVPlayer:(AVPlayer *)player;
@end
