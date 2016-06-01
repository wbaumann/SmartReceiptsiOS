//
//  WBTrip.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <FMDB/FMResultSet.h>
#import "WBTrip.h"
#import "WBFileManager.h"
#import "Price.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "NSDate+Calculations.h"
#import "WBCurrency.h"
#import "NSString+Validation.h"
#import "WBPreferences.h"
#import "SmartReceipts-Swift.h"

NSString *const MULTI_CURRENCY = @"XXXXXX";

@interface WBTrip ()

@property (nonatomic, copy) NSString *originalName;

@end

@implementation WBTrip {
    float _miles;
}

+ (NSString *)MULTI_CURRENCY {
    return MULTI_CURRENCY;
}

- (id)init {
    self = [super init];
    if (self) {
        _startTimeZone = [NSTimeZone localTimeZone];
        _endTimeZone = [NSTimeZone localTimeZone];
    }

    return self;
}

- (NSString *)directoryPath {
    return [self directoryPathUsingName:self.name];
}

- (NSString *)directoryPathUsingName:(NSString *)name {
    return [[WBFileManager tripsDirectoryPath] stringByAppendingPathComponent:name];
}

- (NSString *)fileInDirectoryPath:(NSString *)filename {
    return [[self directoryPath] stringByAppendingPathComponent:filename];
}

- (void)setName:(NSString *)name {
    _name = [[name lastPathComponent] mutableCopy];

    if (self.originalName.hasValue) {
        return;
    }

    [self setOriginalName:_name];
}

- (float)miles {
    return _miles;
}

- (void)setMileage:(float)mileage {
    if (mileage < 0) {
        mileage = 0;
    }
    _miles = mileage;
}

- (BOOL)createDirectoryIfNotExists {
    NSString *dir = [self directoryPath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError *error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:dir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error]) {
            return true;
        } else {
            NSLog(@"Couldn't create trip directory: %@", [error localizedDescription]);
            return false;
        }
    }
    return true;
}

- (NSString *)formattedPrice {
    return self.pricesSummary.currencyFormattedPrice;
}

- (BOOL)dateOutsideTripBounds:(NSDate *)date {
    return [date isBeforeDate:self.startDate] || [date isAfterDate:self.endDate];
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    [self setName:[resultSet stringForColumn:TripsTable.COLUMN_NAME]];

    NSString *currencyCode = [resultSet stringForColumn:TripsTable.COLUMN_DEFAULT_CURRENCY];
    if (!currencyCode.hasValue) {
        currencyCode = [WBPreferences defaultCurrency];
    }
    self.defaultCurrency = [WBCurrency currencyForCode:currencyCode];
    long long int startDateMilliseconds = [resultSet longLongIntForColumn:TripsTable.COLUMN_FROM];
    _startDate = [NSDate dateWithMilliseconds:startDateMilliseconds];
    _startTimeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:TripsTable.COLUMN_FROM_TIMEZONE]];
    long long int endDateMilliseconds = [resultSet longLongIntForColumn:TripsTable.COLUMN_TO];
    _endDate = [NSDate dateWithMilliseconds:endDateMilliseconds];
    _endTimeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:TripsTable.COLUMN_TO_TIMEZONE]];
    self.comment = [resultSet stringForColumn:TripsTable.COLUMN_COMMENT];
    self.costCenter = [resultSet stringForColumn:TripsTable.COLUMN_COST_CENTER];
}

- (BOOL)nameChanged {
    return [self.name compare:self.originalName] != NSOrderedSame;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    WBTrip *otherTrip = other;
    return [self.name isEqualToString:otherTrip.name];
}

- (NSUInteger)hash {
    return [self.name hash];
}

@end


