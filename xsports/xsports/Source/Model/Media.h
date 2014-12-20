//
//  Media.h
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Media;
@protocol User
@end
@protocol Comment
@end

@interface Caption : JSONModel
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *text;
@end

@interface Comment : JSONModel
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *text;
@end

@interface Image : JSONModel
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) NSString *url;
@end

@interface Images : JSONModel
@property (strong, nonatomic) Image *low;
@property (strong, nonatomic) Image *standard;
@property (strong, nonatomic) Image *high;
@end

@interface Video : JSONModel
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSString *url;
@end

@interface Videos : JSONModel
@property (strong, nonatomic) Video *low;
@property (strong, nonatomic) Video *standard;
@property (strong, nonatomic) Video *high;
@end

@interface Location : JSONModel
@property (strong, nonatomic) NSString *lid;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@end

@interface Media : JSONModel
@property (strong, nonatomic) NSDictionary *attribution;
@property (strong, nonatomic) Caption *caption;
@property (assign, nonatomic) NSUInteger totalComments;
@property (strong, nonatomic) NSArray<Comment> *comments;
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NSString *filter;
@property (strong, nonatomic) NSString *mid;
@property (strong, nonatomic) Images *images;
@property (strong, nonatomic) Videos *videos;
@property (assign, nonatomic) NSUInteger totalLikes;
@property (strong, nonatomic) NSArray<User> *likes;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) User *creator;
@property (assign, nonatomic) BOOL isLike;

@property (assign, nonatomic) CGFloat flowLayoutHeight;
- (BOOL)isVideo;
@end
