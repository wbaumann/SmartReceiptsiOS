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

- (NSInteger)days {
    return self.timeIntervalSince1970/(60 * 60 * 24);
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate gregorian] components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd {
    return [[NSDate gregorian] dateByAddingUnit:NSCalendarUnitDay value:daysToAdd toDate:self options:NSCalendarMatchNextTime];
}

- (BOOL)isOnSameDate:(NSDate *)date {
    enum NSCalendarUnit dayComponents = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *otherComponents = [[NSDate gregorian] components:dayComponents fromDate:date];
    NSDateComponents *myComponents = [[NSDate gregorian] components:dayComponents fromDate:self];

    return otherComponents.year == myComponents.year && otherComponents.month == myComponents.month && otherComponents.day == myComponents.day;

    return NO;
}

- (NSTimeInterval)secondsOfDay {
    return [self timeIntervalSince1970] - [[self dateAtBeginningOfDay] timeIntervalSince1970];
}

- (BOOL)isBeforeDate:(NSDate *)date {
    return [[self earlierDate:date] isEqualToDate:self];
}

- (BOOL)isAfterDate:(NSDate *)date {
    return [[self laterDate:date] isEqualToDate:self];
}

- (NSNumber *)milliseconds {
    return @((long long int)([self timeIntervalSince1970] * 1000));
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

- (NSDate *)dateAtBeginningOfDay {
    return [NSDate dateForUnit:NSCalendarUnitDay beforeDate:self];
}

- (NSDate *)dateAtEndOfDay {
    // beginnning of day
    NSDate *result = [NSDate dateForUnit:NSCalendarUnitDay beforeDate:self];
    // beginning of next day
    result = [result dateByAddingDays:1];
    //end of day
    return [NSDate dateWithTimeInterval:-1 sinceDate:result];
}

+ (NSDate *)dateForUnit:(NSCalendarUnit)unit beforeDate:(NSDate *)date {
    NSDate *result;
    [[NSDate gregorian] rangeOfUnit:unit
                          startDate:&result
                           interval:0
                            forDate:date];
    return result;
}

@end
