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
    if (value.length > 0) {
        return [NSDecimalNumber decimalNumberWithString:value];
    } else {
        return [NSDecimalNumber zero];
    }
}

+ (NSDecimalNumber *)decimalNumberOrZero:(NSString *)value withLocale:(NSLocale *)locale {
    if (value.length > 0) {
        return [NSDecimalNumber decimalNumberWithString:value locale:locale];
    } else {
        return [NSDecimalNumber zero];
    }
}

@end
