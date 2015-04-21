//
//  WBTrip.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBCurrency;

@interface WBTrip : NSObject

@property (nonatomic, strong) NSDecimalNumber *price;

+(NSString*) MULTI_CURRENCY;

- (id)initWithName:(NSString *)dirName price:(NSDecimalNumber *)price startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTimeZone:(NSTimeZone *)startTimeZone endTimeZone:(NSTimeZone *)endTimeZone currency:(WBCurrency *)currency miles:(float)miles;

- (id)initWithName:(NSString *)dirName price:(NSDecimalNumber *)price startDateMs:(long long)startDateMs endDateMs:(long long)endDateMs startTimeZoneName:(NSString *)startTimeZoneName endTimeZoneName:(NSString *)endTimeZoneName currencyCode:(NSString *)currencyCode miles:(float)miles;

- (id)initWithName:(NSString *)dirName startDate:(NSDate *)startDate endDate:(NSDate *)endDate currencyCode:(NSString *)currencyCode;

-(NSString*) directoryPath;
-(NSString*) fileInDirectoryPath:(NSString*) filename;

-(NSString*) name;

-(float) miles;
-(NSString*) price_as_string;

-(NSDate*) startDate;
-(NSDate*) endDate;

-(NSTimeZone*) startTimeZone;
-(NSTimeZone*) endTimeZone;

-(WBCurrency*) currency;

-(void) setMileage:(float) mileage;
-(void) setCurrencyFromCode:(NSString*) currencyCode;

-(BOOL) createDirectoryIfNotExists;

-(NSString*)priceWithCurrencyFormatted;

@end
