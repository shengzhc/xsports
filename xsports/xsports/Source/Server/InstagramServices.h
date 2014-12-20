//
//  InstagramServices.h
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramServices : NSObject

+ (InstagramServices *)sharedInstance;
- (AFHTTPRequestOperation *)getPopularMediaWithSuccessBlock:(void (^)(NSError *error, id response))success failBlock:(void (^)(NSError *error, id response))failure;
- (AFHTTPRequestOperation *)getLikesWithMediaId:(NSString *)mediaId successBlock:(void (^)(NSError *error, NSArray *likers))success failBlock:(void (^)(NSError *error, id response))failure;
- (AFHTTPRequestOperation *)getCommentsWithMediaId:(NSString *)mediaId successBlock:(void (^)(NSError *error, id response))success failBlock:(void (^)(NSError *error, id response))failure;
- (AFHTTPRequestOperation *)getUserInfoWithUserId:(NSString *)userId successBlock:(void (^)(NSError *error, id response))success failBlock:(void (^)(NSError *error, id response))failure;

@end
