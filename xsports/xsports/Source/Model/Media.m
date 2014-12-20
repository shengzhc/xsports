//
//  Media.m
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "Media.h"
static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;


@implementation Caption
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"created_time": @"createdTime", @"from": @"creator", @"id": @"cid", @"text": @"text"}];
}
@end

@implementation Comment
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"created_time": @"createdTime", @"from": @"creator", @"id": @"cid", @"text": @"text"}];
}
@end

@implementation Image
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"height": @"height", @"url": @"url", @"width": @"width"}];
}
@end

@implementation Images
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"low_resolution": @"low", @"standard_resolution": @"standard", @"thumbnail": @"high"}];
}
@end

@implementation Video
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"height": @"height", @"url": @"url", @"width": @"width"}];
}
@end

@implementation Videos
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"low_bandwidth": @"low", @"standard_resolution": @"standard", @"low_resolution": @"high"}];
}
@end


@implementation Location
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"lid", @"latitude": @"latitude", @"longitude": @"longitude", @"name": @"name"}];
}
@end

@implementation Media
+ (BOOL)propertyIsOptional:(NSString *)propertyName { return YES; }
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"attribution": @"attribution", @"caption": @"caption", @"comments.count": @"totalComments",
                                                       @"comments.data": @"comments", @"created_time": @"createdTime", @"filter": @"filter",
                                                       @"id": @"mid", @"images": @"images",
                                                       @"videos": @"videos", @"likes.count": @"totalLikes",
                                                       @"likes.data": @"likes",
                                                       @"link": @"link", @"location": @"location",
                                                       @"type": @"type", @"user": @"creator"}];
}

- (BOOL)isVideo
{
    if ([[self.type lowercaseString] isEqualToString:@"video"] && self.videos.standard) {
        return YES;
    }
    return NO;
}

@end
