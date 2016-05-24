//
//  Price.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBCurrency;

@interface Price : NSObject

@property (nonatomic, strong, readonly) NSDecimalNumber *amount;
@property (nonatomic, strong, readonly) WBCurrency *currency;
@property (nonatomic, strong) NSDecimalNumber *exchangeRate;

+ (Price *)priceWithAmount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode;
- (NSString *)currencyFormattedPrice;
+ (Price *)zeroPriceWithCurrencyCode:(NSString *)currencyCode;
- (NSString *)amountAsString;
+ (NSString *)amountAsString:(NSDecimalNumber *)amount;

@end
