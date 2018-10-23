//
//  WBTrip.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"

@class Currency;
@class Price;
@class PricesCollection;

@interface WBTrip : NSObject <FetchedModel>

@property (nonatomic) NSInteger objectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) PricesCollection *pricesSummary;
@property (nonatomic, strong) Currency *defaultCurrency;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *costCenter;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSTimeZone *startTimeZone;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSTimeZone *endTimeZone;
@property (nonatomic, strong) NSDate *lastLocalModificationTime;

- (NSString *)directoryPath;
- (NSString *)fileInDirectoryPath:(NSString *)filename;
- (float)miles;
- (void)setMileage:(float)mileage;
- (BOOL)createDirectoryIfNotExists;
- (NSString *)formattedPrice;
- (BOOL)dateOutsideTripBounds:(NSDate *)date;

@end
