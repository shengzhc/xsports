//
//  Media.m
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "Media.h"

@implementation Caption
- (instancetype)initWithJsonObject:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        
    }
    return self;
}
@end

@implementation Comment
- (instancetype)initWithJsonObject:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation Image
- (instancetype)initWithJsonObject:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation Location
- (instancetype)initWithJsonObject:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation Media
- (instancetype)initWithJsonObject:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        self.attribution = [jsonObject objectForKey:@"attribution"];
    }
    return self;
}
@end
