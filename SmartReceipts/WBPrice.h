//
//  WBPrice.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBCurrency;

@interface WBPrice : NSObject

@property (nonatomic, strong, readonly) NSDecimalNumber *value;
@property (nonatomic, strong, readonly) WBCurrency *currency;

+ (WBPrice *)priceWithAmount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode;
- (NSString *)currencyFormattedPrice;

@end
