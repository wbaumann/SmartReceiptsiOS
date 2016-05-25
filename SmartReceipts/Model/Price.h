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

@property (nonatomic, strong, readonly) NSDecimalNumber *__nonnull amount;
@property (nonatomic, strong, readonly) WBCurrency *__nonnull currency;
@property (nonatomic, strong) NSDecimalNumber *__nullable exchangeRate;

+ (Price *__nonnull)priceWithAmount:(NSDecimalNumber *__nonnull)amount currencyCode:(NSString *__nonnull)currencyCode;
- (NSString *__nonnull)currencyFormattedPrice;
+ (Price *__nonnull)zeroPriceWithCurrencyCode:(NSString *__nonnull)currencyCode;
- (NSString *__nonnull)amountAsString;
+ (NSString *__nonnull)amountAsString:(NSDecimalNumber *__nonnull)amount;

@end
