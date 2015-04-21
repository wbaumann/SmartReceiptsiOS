//
//  WBTrip.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTrip.h"
#import "WBCurrency.h"
#import "WBFileManager.h"

static NSString * const MULTI_CURRENCY = @"XXXXXX";

@implementation WBTrip
{
    NSString* _reportDirectoryName;
    NSDate *_startDate, *_endDate;
    NSTimeZone *_startTimeZone, *_endTimeZone;
    WBCurrency *_currency;
    float _miles;
}

+(NSString*) MULTI_CURRENCY{
    return MULTI_CURRENCY;
}

- (id)initWithName:(NSString *)dirName price:(NSDecimalNumber *)price startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTimeZone:(NSTimeZone *)startTimeZone endTimeZone:(NSTimeZone *)endTimeZone currency:(WBCurrency *)currency miles:(float) miles
{
    self = [super init];
    if (self) {
        _reportDirectoryName = [dirName lastPathComponent];
        _price = price;
        _startDate = startDate;
        _endDate = endDate;
        _startTimeZone = startTimeZone;
        _endTimeZone = endTimeZone;
        _currency = currency;
        _miles = miles;
    }
    return self;
}

- (id)initWithName:(NSString *)dirName price:(NSDecimalNumber *)price startDateMs:(long long)startDateMs endDateMs:(long long)endDateMs startTimeZoneName:(NSString *)startTimeZoneName endTimeZoneName:(NSString *)endTimeZoneName currencyCode:(NSString *)currencyCode miles:(float) miles
{
    NSTimeZone *startTimeZone = [NSTimeZone timeZoneWithName:startTimeZoneName];
    if (!startTimeZone) {
        startTimeZone = [NSTimeZone localTimeZone];
    }
    
    NSTimeZone *endTimeZone = [NSTimeZone timeZoneWithName:endTimeZoneName];
    if (!endTimeZone) {
        endTimeZone = [NSTimeZone localTimeZone];
    }
    
    self = [self initWithName:dirName
                        price:price
                    startDate:[NSDate dateWithTimeIntervalSince1970:(startDateMs/1000)]
                      endDate:[NSDate dateWithTimeIntervalSince1970:(endDateMs/1000)]
                startTimeZone:startTimeZone
                  endTimeZone:endTimeZone
                     currency:[WBCurrency currencyForCode:currencyCode]
                        miles:miles];
    
    return self;
}

- (id)initWithName:(NSString*) dirName startDate:(NSDate*) startDate endDate:(NSDate*) endDate currencyCode:(NSString*) currencyCode
{
    self = [self initWithName:dirName
                        price:[NSDecimalNumber zero]
                    startDate:startDate
                      endDate:endDate
                startTimeZone:[NSTimeZone localTimeZone]
                  endTimeZone:[NSTimeZone localTimeZone]
                     currency:[WBCurrency currencyForCode:currencyCode]
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

-(NSString*) price_as_string {
    return [NSString stringWithFormat:@"%@", _price];
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

-(WBCurrency*) currency {
    return _currency;
}

-(void) setMileage:(float) mileage {
    if (mileage<0) {
        mileage = 0;
    }
    _miles = mileage;
}

-(void) setCurrencyFromCode:(NSString*) currencyCode {
    _currency = [WBCurrency currencyForCode:currencyCode];
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
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setCurrencyCode:[[self currency] code]];
    return [_currencyFormatter stringFromNumber:_price];
}

@end


