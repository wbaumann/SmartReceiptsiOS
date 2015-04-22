//
//  NSDecimalNumber+WBNumberParse.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (WBNumberParse)

+ (NSDecimalNumber *)decimalNumberOrZero:(NSString *)value;
+ (NSDecimalNumber *)decimalNumberOrZero:(NSString *)value withLocale:(NSLocale *)locale;

@end
