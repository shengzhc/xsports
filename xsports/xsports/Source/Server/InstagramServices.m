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
        NSLog(@"AAA");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"BBB");
    }];
    
    return operation;
}

@end
