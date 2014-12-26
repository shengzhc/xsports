//
//  MPMoviePlayerController+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/25/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "MPMoviePlayerController+XS.h"

@implementation MPMoviePlayerController (XS)

+ (MPMoviePlayerController *)sharedMoviePlayerController
{
    static MPMoviePlayerController *moviePlayerController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moviePlayerController = [[MPMoviePlayerController alloc] init];
    });
    return moviePlayerController;
}

@end
