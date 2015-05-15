//
//  NSString+Helpers.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 15/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

- (NSString *)trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
