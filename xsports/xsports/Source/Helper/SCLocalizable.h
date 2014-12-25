//
//  SCLocalizable.h
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLocalizable : NSObject

+ (NSString *)localizedStringForKey:(NSString *)key table:(NSString *)table;

@end
