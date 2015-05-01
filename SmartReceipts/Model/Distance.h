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

@interface Distance : NSObject

- (id)initWithDistance:(NSDecimalNumber *)distance
                  rate:(WBPrice *)rate
              location:(NSString *)location
                  date:(NSDate *)date
               comment:(NSString *)comment;

@end
