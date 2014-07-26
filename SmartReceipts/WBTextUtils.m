//
//  WBTextUtils.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTextUtils.h"

#warning FIXME: on Android '_' character is allowed, here not, because it gives user option to enter shared_prefs name that creates trash during exports (the same applies to Internal folder), it's not critical bug but app takes more space
static NSString * const RESERVED_CHARS = @"_|\\?*<\":>+[]/'\n\r\t\0\f";

static BOOL matchRegex(NSString *expression, NSString *text)
{
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:expression
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:text
                                  options:0
                                  range:NSMakeRange(0, [text length])];
    
    return numberOfMatches > 0;
}

@implementation WBTextUtils

+(BOOL)isMoney:(NSString*) text
{
    NSString *expression = @"^\\-?([0-9]{1,10})?(\\.([0-9]{1,2})?)?$";
    return matchRegex(expression,text);
}

+(BOOL)isNonnegativeMoney:(NSString*) text
{
    NSString *expression = @"^([0-9]{1,10})?(\\.([0-9]{1,2})?)?$";
    return matchRegex(expression,text);
}

+(BOOL)isNonnegativeInteger:(NSString*) text
{
    if ([text length] <= 0) {
        return true; // it's zero then
    }
    NSString *expression = @"^0|[1-9][0-9]*$";
    return matchRegex(expression,text);
}

+(BOOL)isProperName:(NSString*) name {
    NSCharacterSet *blockedCharacters = [NSCharacterSet characterSetWithCharactersInString:RESERVED_CHARS];
    return ([name rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

@end

