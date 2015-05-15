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
#import "WBPrice.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "NSDate+Calculations.h"
#import "WBCurrency.h"

NSString *const MULTI_CURRENCY = @"XXXXXX";

@implementation WBTrip
{
    NSDate *_startDate, *_endDate;
    NSTimeZone *_startTimeZone, *_endTimeZone;
    float _miles;
}

+(NSString*) MULTI_CURRENCY{
    return MULTI_CURRENCY;
}

- (id)initWithName:(NSString *)dirName price:(WBPrice *)price startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTimeZone:(NSTimeZone *)startTimeZone endTimeZone:(NSTimeZone *)endTimeZone miles:(float) miles
{
    self = [super init];
    if (self) {
        if (!startTimeZone) {
            startTimeZone = [NSTimeZone localTimeZone];
        }

        if (!endTimeZone) {
            endTimeZone = [NSTimeZone localTimeZone];
        }

        _reportDirectoryName = [dirName lastPathComponent];
        _price = price;
        _startDate = startDate;
        _endDate = endDate;
        _startTimeZone = startTimeZone;
        _endTimeZone = endTimeZone;
        _miles = miles;
    }
    return self;
}

- (id)initWithName:(NSString*) dirName startDate:(NSDate*) startDate endDate:(NSDate*) endDate currencyCode:(NSString*) currencyCode
{
    self = [self initWithName:dirName
                        price:[WBPrice zeroPriceWithCurrencyCode:currencyCode]
                    startDate:startDate
                      endDate:endDate
                startTimeZone:[NSTimeZone localTimeZone]
                  endTimeZone:[NSTimeZone localTimeZone]
                        miles:0];
    
    return self;
}

-(NSString*) directoryPath {
    return [[WBFileManager tripsDirectoryPath] stringByAppendingPathComponent:_reportDirectoryName];
}

-(NSString*) fileInDirectoryPath:(NSString*) filename {
    return [[self directoryPath] stringByAppendingPathComponent:filename];
}

-(NSString*) name {
    return _reportDirectoryName;
}

-(float) miles {
    return _miles;
}

-(NSDate*) startDate {
    return _startDate;
}

-(NSDate*) endDate {
    return _endDate;
}

-(NSTimeZone*) startTimeZone {
    return _startTimeZone;
}

-(NSTimeZone*) endTimeZone {
    return _endTimeZone;
}

-(void) setMileage:(float) mileage {
    if (mileage<0) {
        mileage = 0;
    }
    _miles = mileage;
}

-(BOOL) createDirectoryIfNotExists {
    NSString* dir = [self directoryPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError *error;
        if([[NSFileManager defaultManager] createDirectoryAtPath:dir
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error]){
            return true;
        } else {
            NSLog(@"Couldn't create trip directory: %@", [error localizedDescription]);
            return false;
        }
    }
    return true;
}

-(NSString*)priceWithCurrencyFormatted {
    return self.price.currencyFormattedPrice;
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    _reportDirectoryName = [resultSet stringForColumn:TripsTable.COLUMN_NAME];

    NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumn:TripsTable.COLUMN_PRICE]];
    NSString *currencyCode = [resultSet stringForColumn:TripsTable.COLUMN_DEFAULT_CURRENCY];
    self.defaultCurrency = [WBCurrency currencyForCode:currencyCode];
    _price = [WBPrice priceWithAmount:price currencyCode:currencyCode];
    long long int startDateMilliseconds = [resultSet longLongIntForColumn:TripsTable.COLUMN_FROM];
    _startDate = [NSDate dateWithMilliseconds:startDateMilliseconds];
    _startTimeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:TripsTable.COLUMN_FROM_TIMEZONE]];
    long long int endDateMilliseconds = [resultSet longLongIntForColumn:TripsTable.COLUMN_FROM];
    _endDate = [NSDate dateWithMilliseconds:endDateMilliseconds];
    _endTimeZone = [NSTimeZone timeZoneWithName:[resultSet stringForColumn:TripsTable.COLUMN_TO_TIMEZONE]];
    self.comment = [resultSet stringForColumn:TripsTable.COLUMN_COMMENT];
    self.costCenter = [resultSet stringForColumn:TripsTable.COLUMN_COST_CENTER];
}

@end


