//
//  NSDate+XS.m
//  xsports
//
//  Created by Shengzhe Chen on 12/15/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "NSDate+XS.h"

@implementation NSDate (XS)

- (NSString *)dateOffset
{
    NSDate *today = [NSDate date];
    NSUInteger unitFlags = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([today compare:self] == NSOrderedAscending) {
        return @"1m";
    }
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:today options:0];
    
    if (components.weekday != 0) {
        return [NSString stringWithFormat:@"%@w", @(components.weekday)];
    } else if (components.day != 0) {
        return [NSString stringWithFormat:@"%@d", @(components.day)];
    } else if (components.hour != 0) {
        return [NSString stringWithFormat:@"%@h", @(components.hour)];
    } else if (components.minute != 0) {
        return [NSString stringWithFormat:@"%@m", @(components.minute)];
    } else if (components.second != 0){
        return [NSString stringWithFormat:@"%@m", @(components.second)];
    }
    return @"1m";
}

@end
