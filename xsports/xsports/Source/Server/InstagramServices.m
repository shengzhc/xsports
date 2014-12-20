//
//  InstagramServices.m
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "InstagramServices.h"

static const NSString *instagramClientId = @"66836f2b450a466890808946b6e374d9";
static const NSString *instagramSecretId = @"9c939511d38346649600ba65658ebfc4";

@interface InstagramServices ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation InstagramServices

+ (InstagramServices *)sharedInstance
{
    static InstagramServices *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InstagramServices alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com"]];
    }
    return self;
}

- (AFHTTPRequestOperation *)getPopularMediaWithSuccessBlock:(void (^)(NSError *error, id response))success failBlock:(void (^)(NSError *error, id response))failure
{
    AFHTTPRequestOperation *operation = [self.manager GET:@"/v1/media/popular?"
                                               parameters:@{@"client_id": instagramClientId, @"secret_id": instagramSecretId}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray *medias = [NSMutableArray new];
        for (NSDictionary *media in data) {
            [medias addObject:[[Media alloc] initWithDictionary:media error:nil]];
        }
        if (success) {
            success(nil, medias);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (failure) {
            failure(error, nil);
        }
    }];
    
    return operation;
}

- (AFHTTPRequestOperation *)getLikesWithMediaId:(NSString *)mediaId successBlock:(void (^)(NSError *error, NSArray *likers))success failBlock:(void (^)(NSError *error, id response))failure
{
    AFHTTPRequestOperation *operation = [self.manager GET:[NSString stringWithFormat:@"/v1/media/%@/likes?", mediaId]
                                               parameters:@{@"client_id": instagramClientId, @"secret_id": instagramSecretId}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             NSArray *data = [responseObject objectForKey:@"data"];
                                             NSMutableArray *likers = [NSMutableArray new];
                                             for (NSDictionary *like in data) {
                                                 [likers addObject:[[User alloc] initWithDictionary:like error:nil]];
                                             }
                                             if (success) {
                                                 success(nil, likers);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             if (failure) {
                                                 failure(error, nil);
                                             }
                                         }];
    return operation;
}

- (AFHTTPRequestOperation *)getCommentsWithMediaId:(NSString *)mediaId successBlock:(void (^)(NSError *error, NSArray *comments))success failBlock:(void (^)(NSError *error, id response))failure
{
    AFHTTPRequestOperation *operation = [self.manager GET:[NSString stringWithFormat:@"/v1/media/%@/comments?", mediaId]
                                               parameters:@{@"client_id": instagramClientId, @"secret_id": instagramSecretId}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             NSArray *data = [responseObject objectForKey:@"data"];
                                             NSMutableArray *comments = [NSMutableArray new];
                                             for (NSDictionary *comment in data) {
                                                 [comments addObject:[[Comment alloc] initWithDictionary:comment error:nil]];
                                             }
                                             if (success) {
                                                 success(nil, comments);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             if (failure) {
                                                 failure(error, nil);
                                             }
                                         }];
    return operation;
    
}

- (AFHTTPRequestOperation *)getUserInfoWithUserId:(NSString *)userId successBlock:(void (^)(NSError *error, id response))success failBlock:(void (^)(NSError *error, id response))failure
{
    AFHTTPRequestOperation *operation = [self.manager GET:[NSString stringWithFormat:@"/v1/users/%@?", userId]
                                               parameters:@{@"client_id": instagramClientId, @"secret_id": instagramSecretId}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             NSDictionary *data = [responseObject objectForKey:@"data"];
                                             User *user = [[User alloc] initWithDictionary:data error:nil];
                                             if (success) {
                                                 success(nil, user);
                                             }
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             if (failure) {
                                                 failure(error, nil);
                                             }
                                         }];
    return operation;
}


@end
