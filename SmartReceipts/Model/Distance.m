//
//  Distance.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Distance.h"
#import "Price.h"
#import "WBTrip.h"
#import "FMResultSet.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "NSDate+Calculations.h"

@interface Distance ()

@property (nonatomic, assign) NSUInteger objectId;

@end

@implementation Distance

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(Price *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment {
    self = [super init];
    if (self) {
        _trip = trip;
        _distance = distance;
        _rate = rate;
        _location = location;
        _date = date;
        _timeZone = timeZone;
        _comment = comment;
    }
    return self;
}

- (Price *)totalRate {
    NSDecimalNumber *totalValue = [self.distance decimalNumberByMultiplyingBy:self.rate.amount];
    return [Price priceWithAmount:totalValue currencyCode:self.rate.currency.code];
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    [self setObjectId:(NSUInteger) [resultSet intForColumn:DistanceTable.COLUMN_ID]];
    [self setDistance:[NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumn:DistanceTable.COLUMN_DISTANCE]]];
    NSString *rateString = [resultSet stringForColumn:DistanceTable.COLUMN_RATE];
    NSString *currency = [resultSet stringForColumn:DistanceTable.COLUMN_RATE_CURRENCY];
    [self setRate:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:rateString] currencyCode:currency]];
    [self setLocation:[resultSet stringForColumn:DistanceTable.COLUMN_LOCATION]];
    long long int dateMilliseconds = [resultSet longLongIntForColumn:DistanceTable.COLUMN_DATE];
    [self setDate:[NSDate dateWithMilliseconds:dateMilliseconds]];
    [self setTimeZone:[NSTimeZone timeZoneWithName:[resultSet stringForColumn:DistanceTable.COLUMN_TIMEZONE]]];
    [self setComment:[resultSet stringForColumn:DistanceTable.COLUMN_COMMENT]];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    Distance *otherDistance = other;
    return self.objectId == otherDistance.objectId;
}

- (NSUInteger)hash {
    return @(self.objectId).hash;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"id: %lu", (unsigned long)self.objectId];
    [description appendString:@">"];
    return description;
}

@end
