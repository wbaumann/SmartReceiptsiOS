//
//  WBDateUtils.m
//  SmartReceipts
//
//  Created on 30/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDateFormatter.h"
#import "WBPreferences.h"

@implementation WBDateFormatter
{
    NSDateFormatter *_formatter;
}

- (id)init
{
    self = [super init];
    if (self) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateStyle:NSDateFormatterShortStyle];
        [_formatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return self;
}

-(NSString*) formattedDate:(NSDate*) date inTimeZone:(NSTimeZone*) timeZone {
    [_formatter setTimeZone:timeZone];
    NSString *separator = [WBPreferences dateSeparator];
    NSString *str = [_formatter stringFromDate:date];
    NSString *oppSeparator = [self separatorForCurrentLocale];
    return [str stringByReplacingOccurrencesOfString:oppSeparator withString:separator];
}

-(NSString*) formattedDateMs:(long long)dateMs inTimeZone:(NSTimeZone*) timeZone {
    return [self formattedDate:[NSDate dateWithTimeIntervalSince1970:(dateMs/1000)] inTimeZone:timeZone];
}

-(NSString*) separatorForCurrentLocale {
    static NSString* separator = nil;
    if (separator == nil) {
        separator = [WBDateFormatter findSeparator:_formatter];
    }
    return separator;
}

+(NSString*) findSeparator:(NSDateFormatter*) formatter {
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\w]" options:0 error:nil];
    
    NSTextCheckingResult *match = [regex firstMatchInString:str
                                                     options:0
                                                       range:NSMakeRange(0, [str length])];
    if (match) {
        NSString *sep = [str substringWithRange:[match range]];
        if ([sep length] > 0) {
            return sep;
        }
    }
    
    return @"/";
}

@end
