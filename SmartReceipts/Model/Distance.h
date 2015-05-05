//
//  Distance.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"

@class WBCurrency;
@class WBPrice;
@class WBTrip;
@class FMResultSet;

@interface Distance : NSObject <FetchedModel>

@property (nonatomic, assign, readonly) NSUInteger objectId;
@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong) NSDecimalNumber *distance;
@property (nonatomic, strong) WBPrice *rate;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, copy) NSString *comment;

- (WBPrice *)totalRate;

@end
