//
//  Price.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Price.h"
#import "WBCurrency.h"

@interface Price ()

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) WBCurrency *currency;

@end

@implementation Price

+ (Price *)priceWithAmount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode {
    Price *price = [[Price alloc] init];
    [price setAmount:amount];
    [price setCurrency:[WBCurrency currencyForCode:currencyCode]];
    return price;
}

+ (Price *)priceWithAmount:(NSDecimalNumber *)amount currency:(WBCurrency *)currency {
    Price *price = [[Price alloc] init];
    [price setAmount:amount];
    [price setCurrency:currency];
    return price;
}

+ (Price *)zeroPriceWithCurrencyCode:(NSString *)currencyCode {
    return [Price priceWithAmount:[NSDecimalNumber zero] currencyCode:currencyCode];
}

- (NSString *)amountAsString {
    return [Price amountAsString:self.amount];
}

+ (NSString *)amountAsString:(NSDecimalNumber *)amount {
    static NSString const *noCurrencyKey = @"noCurrencyFormatter";
    NSNumberFormatter *noCurrencyFormatter = [[NSThread currentThread] threadDictionary][noCurrencyKey];
    if (!noCurrencyFormatter) {
        noCurrencyFormatter = [[NSNumberFormatter alloc] init];
        [noCurrencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [noCurrencyFormatter setCurrencySymbol:@""];
        [noCurrencyFormatter setGroupingSeparator:@""];
        noCurrencyFormatter.usesGroupingSeparator = NO;
        [[NSThread currentThread] threadDictionary][noCurrencyKey] = noCurrencyFormatter;
    }

    return [[noCurrencyFormatter stringFromNumber:amount] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)currencyFormattedPrice {
    return [self formattedMoneyString:self.amount];
}

- (NSString *)formattedMoneyString:(NSDecimalNumber *)moneyAmount {
    return [[Price formatterForCurrencyCode:self.currency.code] stringFromNumber:moneyAmount];
}

+ (NSNumberFormatter *)formatterForCurrencyCode:(NSString *)code {
    NSNumberFormatter *formatter = [[NSThread currentThread] threadDictionary][code];
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:code];
        [[NSThread currentThread] threadDictionary][code] = formatter;
    }

    return formatter;
}

@end
