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

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) WBPrice *price;
@property (nonatomic, strong) WBCurrency *defaultCurrency;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *costCenter;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSTimeZone *startTimeZone;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSTimeZone *endTimeZone;

+ (NSString *)MULTI_CURRENCY;

- (NSString *)directoryPath;
- (NSString *)fileInDirectoryPath:(NSString *)filename;
- (float)miles;
- (void)setMileage:(float)mileage;
- (BOOL)createDirectoryIfNotExists;
- (NSString *)priceWithCurrencyFormatted;

@end
