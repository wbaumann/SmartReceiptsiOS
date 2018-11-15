//
//  LocalizedString.m
//  SmartReceipts
//
//  Created by William Baumann on 10/12/18.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

#import "LocalizedString.h"

@implementation LocalizedString

+ (NSString*)from:(NSString *)key comment:(NSString *)comment {
    // By default, attempt to load from our Shared set of strings
    NSString* result = NSLocalizedStringFromTable(key, @"SharedLocalizable", comment);
    if ([result isEqualToString:key]) {
        // If we failed to find this string in our SharedLocalizable.strings file, check Localizable.strings one
        result = NSLocalizedString(key, comment);
    }
    if ([result isEqualToString:key]) {
        // If we cannot find it in either, fall back to English
        NSString* path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        if (path) {
            NSBundle* enBundle = [NSBundle bundleWithPath:path];
            if (enBundle) {
                // Check the English Localizable.strings file
                result = [enBundle localizedStringForKey:key value:@"" table:nil];
                if ([result isEqualToString:key]) {
                    // If we failed to find this string in our SharedLocalizable.strings file, check Localizable.strings one
                    result = [enBundle localizedStringForKey:key value:@"" table:@"SharedLocalizable"];
                }
            }
        }
    }
    return result;
}

@end
