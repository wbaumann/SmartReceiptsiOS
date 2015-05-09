//
// Created by Jaanus Siim on 09/05/15.
// Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import "NSDate+Calculations.h"

static NSString *const SmartReceiptsGregorianCalendarKey = @"SmartReceiptsGregorianCalendarKey";

@implementation NSDate (Calculations)

- (BOOL)isToday {
    enum NSCalendarUnit dayComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *todayComponents = [[NSDate gregorian] components:dayComponents fromDate:[NSDate date]];
    NSDateComponents *myComponents = [[NSDate gregorian] components:dayComponents fromDate:self];

    return todayComponents.year == myComponents.year && todayComponents.month == myComponents.month && todayComponents.day == myComponents.day;
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate gregorian] components:NSYearCalendarUnit fromDate:self];
    return components.year;
}

- (NSNumber *)milliseconds {
    return @([self timeIntervalSince1970] * 1000);
}

+ (NSCalendar *)gregorian {
    NSCalendar *calendar = [[NSThread currentThread] threadDictionary][SmartReceiptsGregorianCalendarKey];
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [[NSThread currentThread] threadDictionary][SmartReceiptsGregorianCalendarKey] = calendar;
    }

    return calendar;
}

+ (NSDate *)dateWithMilliseconds:(long long int)milliseconds {
    return [NSDate dateWithTimeIntervalSince1970:(milliseconds / 1000.0)];
}

@end