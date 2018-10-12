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
    NSString* result = NSLocalizedString(key, comment);
    if ([result isEqualToString:key]) {
        result = NSLocalizedStringFromTable(key, @"SharedLocalizable", comment);
    }
    return result;
}

@end
