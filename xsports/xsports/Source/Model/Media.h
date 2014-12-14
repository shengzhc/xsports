//
//  Media.h
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caption : NSObject
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *text;
@end

@interface Comment : NSObject
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *text;
@end

@interface Image : NSObject
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) NSString *url;
@end

@interface Location : NSObject
@property (strong, nonatomic) NSString *lid;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@end

@interface Media : NSObject
@property (strong, nonatomic) NSDictionary *attribution;
@property (strong, nonatomic) Caption *caption;
@property (assign, nonatomic) NSUInteger totalComments;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NSString *filter;
@property (strong, nonatomic) NSString *mid;
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) NSUInteger totalLikes;
@property (strong, nonatomic) NSArray *likes;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) User *creator;
@end
