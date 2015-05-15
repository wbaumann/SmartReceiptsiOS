//
//  WBTrip.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"

@class WBCurrency;
@class WBPrice;

extern NSString *const MULTI_CURRENCY;

@interface WBTrip : NSObject <FetchedModel>

@property (nonatomic, copy) NSString *reportDirectoryName;
@property (nonatomic, strong) WBPrice *price;
@property (nonatomic, strong) WBCurrency *defaultCurrency;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *costCenter;

+(NSString*) MULTI_CURRENCY;

- (id)initWithName:(NSString *)dirName price:(WBPrice *)price startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTimeZone:(NSTimeZone *)startTimeZone endTimeZone:(NSTimeZone *)endTimeZone miles:(float)miles;

- (id)initWithName:(NSString *)dirName startDate:(NSDate *)startDate endDate:(NSDate *)endDate currencyCode:(NSString *)currencyCode;

-(NSString*) directoryPath;
-(NSString*) fileInDirectoryPath:(NSString*) filename;

-(NSString*) name;

-(float) miles;

-(NSDate*) startDate;
-(NSDate*) endDate;

-(NSTimeZone*) startTimeZone;
-(NSTimeZone*) endTimeZone;

-(void) setMileage:(float) mileage;

-(BOOL) createDirectoryIfNotExists;

-(NSString*)priceWithCurrencyFormatted;

@end
