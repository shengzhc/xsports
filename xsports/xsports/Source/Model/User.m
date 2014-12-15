//
//  User.m
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "User.h"

@implementation User

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"full_name": @"fullName",
                                                       @"id": @"uid",
                                                       @"profile_picture": @"profilePicture",
                                                       @"username": @"userName",
                                                       @"bio": @"bio",
                                                       @"website": @"website"}];
}

@end
