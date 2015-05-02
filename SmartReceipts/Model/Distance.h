//
//  Distance.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBCurrency;
@class WBPrice;
@class WBTrip;
@class FMResultSet;

@interface Distance : NSObject

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong, readonly) NSDecimalNumber *distance;
@property (nonatomic, strong, readonly) WBPrice *rate;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong, readonly) NSTimeZone *timeZone;
@property (nonatomic, copy, readonly) NSString *comment;

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment;
- (WBPrice *)totalRate;

+ (Distance *)createFromResultSet:(FMResultSet *)resultSet;

@end
