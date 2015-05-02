//
//  Distance.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Distance.h"
#import "WBPrice.h"
#import "WBTrip.h"
#import "FMResultSet.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "WBCurrency.h"

@interface Distance ()

@property (nonatomic, assign) NSUInteger *objectId;
@property (nonatomic, strong) NSDecimalNumber *distance;
@property (nonatomic, strong) WBPrice *rate;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, copy) NSString *comment;

@end

@implementation Distance

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment {
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

- (WBPrice *)totalRate {
    NSDecimalNumber *totalValue = [self.distance decimalNumberByMultiplyingBy:self.rate.amount];
    return [WBPrice priceWithAmount:totalValue currencyCode:self.rate.currency.code];
}

+ (Distance *)createFromResultSet:(FMResultSet *)resultSet {
    Distance *distance = [[Distance alloc] init];
    [distance setObjectId:(NSUInteger *) [resultSet intForColumn:DistanceTable.COLUMN_ID]];
    [distance setDistance:[NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumn:DistanceTable.COLUMN_DISTANCE]]];
    NSString *rateString = [resultSet stringForColumn:DistanceTable.COLUMN_RATE];
    NSString *currency = [resultSet stringForColumn:DistanceTable.COLUMN_RATE_CURRENCY];
    [distance setRate:[WBPrice priceWithAmount:[NSDecimalNumber decimalNumberOrZero:rateString] currencyCode:currency]];
    [distance setLocation:[resultSet stringForColumn:DistanceTable.COLUMN_LOCATION]];
    [distance setDate:[resultSet dateForColumn:DistanceTable.COLUMN_DATE]];
    [distance setTimeZone:[NSTimeZone timeZoneWithName:[resultSet stringForColumn:DistanceTable.COLUMN_TIMEZONE]]];
    [distance setComment:[resultSet stringForColumn:DistanceTable.COLUMN_COMMENT]];
    return distance;
}

@end
