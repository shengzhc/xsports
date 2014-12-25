//
//  SCLocalizable.m
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SCLocalizable.h"

@implementation SCLocalizable

+ (NSString *)localizedStringForKey:(NSString *)key table:(NSString *)table
{
    if (!table) table = @"Localizable";
    NSString* space = @" ";
    NSString* language = [SCLocalizable language];
    NSString* countryCode = [[SCLocalizable countryCode] uppercaseString];
    NSString* languageAndRegion = [[language stringByAppendingString:@"_"] stringByAppendingString:countryCode];
    NSString* path = [[NSBundle mainBundle] pathForResource:languageAndRegion ofType:@"lproj"];
    if (path == nil) {
        path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    }
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* value = [languageBundle localizedStringForKey:key value:space table:table];
    if (value.length != 0 && [value characterAtIndex:0] != ' ') {
        return value;
    }
    
    path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    languageBundle = [NSBundle bundleWithPath:path];
    value = [languageBundle localizedStringForKey:key value:space table:table];
    if (value.length != 0 && [value characterAtIndex:0] != ' ') {
        return value;
    }
    
    path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
    languageBundle = [NSBundle bundleWithPath:path];
    value = [languageBundle localizedStringForKey:key value:key table:table];
    return value;
}

+ (NSString*) language
{
    return [[[NSLocale preferredLanguages] objectAtIndex:0] lowercaseString];
}

+ (NSString*) countryCode
{
    return [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] lowercaseString];
}

@end
