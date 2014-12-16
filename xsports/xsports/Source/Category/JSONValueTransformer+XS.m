//
//  JSONValueTransformer+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "JSONValueTransformer+XS.h"

@implementation JSONValueTransformer (XS)

- (NSDate *)NSDateFromNSString:(NSString*)string
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[string  longLongValue]];
    return date;
}

@end
