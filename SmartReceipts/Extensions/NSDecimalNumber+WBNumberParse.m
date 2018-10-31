//
//  NSDecimalNumber+WBNumberParse.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NSDecimalNumber+WBNumberParse.h"

@implementation NSDecimalNumber (WBNumberParse)

+ (NSDecimalNumber *)decimalNumberOrZero:(NSString *)value {
    NSString *replaced = [value stringByReplacingOccurrencesOfString:@"," withString:@"."];
    if (value.length > 0) {
        return [NSDecimalNumber decimalNumberWithString:replaced];
    } else {
        return [NSDecimalNumber zero];
    }
}

+ (NSDecimalNumber *)decimalNumberOrZeroUsingCurrentLocale:(NSString *)value {
    if (value.length > 0) {
        return [NSDecimalNumber decimalNumberWithString:value locale:[NSLocale currentLocale]];
    } else {
        return [NSDecimalNumber zero];
    }
}

@end
