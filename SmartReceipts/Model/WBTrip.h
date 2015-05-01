//
//  WBTrip.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBCurrency;
@class WBPrice;

extern NSString *const MULTI_CURRENCY;

@interface WBTrip : NSObject

@property (nonatomic, strong) WBPrice *price;

+(NSString*) MULTI_CURRENCY;

- (id)initWithName:(NSString *)dirName price:(WBPrice *)price startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTimeZone:(NSTimeZone *)startTimeZone endTimeZone:(NSTimeZone *)endTimeZone miles:(float)miles;

- (id)initWithName:(NSString *)dirName price:(WBPrice *)price startDateMs:(long long)startDateMs endDateMs:(long long)endDateMs startTimeZoneName:(NSString *)startTimeZoneName endTimeZoneName:(NSString *)endTimeZoneName miles:(float)miles;

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

-(void) setMileage:(float) mileage;

-(BOOL) createDirectoryIfNotExists;

-(NSString*)priceWithCurrencyFormatted;

@end
