//
//  User.h
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : JSONModel
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *profilePicture;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *website;
@end
