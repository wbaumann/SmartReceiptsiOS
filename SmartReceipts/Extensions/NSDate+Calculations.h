//
// Created by Jaanus Siim on 09/05/15.
// Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calculations)

- (BOOL)isToday;
- (NSInteger)year;
- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd;
- (BOOL)isOnSameDate:(NSDate *)date;
- (NSDate *)dateAtBeginningOfDay;
- (NSDate *)dateAtEndOfDay;
- (NSTimeInterval)secondsOfDay;

- (NSNumber *)milliseconds;
+ (NSDate *)dateWithMilliseconds:(long long int)milliseconds;


@end