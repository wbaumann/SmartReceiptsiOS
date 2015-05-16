//
// Created by Jaanus Siim on 09/05/15.
// Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NSDate+Calculations.h"

static NSString *const SmartReceiptsGregorianCalendarKey = @"SmartReceiptsGregorianCalendarKey";

@implementation NSDate (Calculations)

- (BOOL)isToday {
    return [self isOnSameDate:[NSDate date]];
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate gregorian] components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd {
    return [self dateByAddingTimeInterval:60 * 60 * 24 * daysToAdd];
}

- (BOOL)isOnSameDate:(NSDate *)date {
    enum NSCalendarUnit dayComponents = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *otherComponents = [[NSDate gregorian] components:dayComponents fromDate:date];
    NSDateComponents *myComponents = [[NSDate gregorian] components:dayComponents fromDate:self];

    return otherComponents.year == myComponents.year && otherComponents.month == myComponents.month && otherComponents.day == myComponents.day;

    return NO;
}

- (NSNumber *)milliseconds {
    return @([self timeIntervalSince1970] * 1000);
}

+ (NSCalendar *)gregorian {
    NSCalendar *calendar = [[NSThread currentThread] threadDictionary][SmartReceiptsGregorianCalendarKey];
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [[NSThread currentThread] threadDictionary][SmartReceiptsGregorianCalendarKey] = calendar;
    }

    return calendar;
}

+ (NSDate *)dateWithMilliseconds:(long long int)milliseconds {
    return [NSDate dateWithTimeIntervalSince1970:(milliseconds / 1000.0)];
}

@end