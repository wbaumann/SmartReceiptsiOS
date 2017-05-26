//
//  Price.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Price.h"

@interface Price ()

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) Currency *currency;

@end

@implementation Price

+ (Price *)priceWithAmount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode {
    Price *price = [[Price alloc] init];
    [price setAmount:amount];
    [price setCurrency:[Currency currencyForCode:currencyCode]];
    return price;
}

+ (Price *)priceWithAmount:(NSDecimalNumber *)amount currency:(Currency *)currency {
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
        [noCurrencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [noCurrencyFormatter setMinimumFractionDigits:2];
        [noCurrencyFormatter setMaximumFractionDigits:2];
        [noCurrencyFormatter setUsesGroupingSeparator:false];
        [[NSThread currentThread] threadDictionary][noCurrencyKey] = noCurrencyFormatter;
    }

    return [[noCurrencyFormatter stringFromNumber:amount] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (NSString *)mileageRateAmountAsString {
    return [Price mileageRateAmountAsString:self.amount];
}

+ (NSString *)mileageRateAmountAsString:(NSDecimalNumber *)amount {
    static NSString const *noCurrencyRateKey = @"noCurrencyRateFormatter";
    NSNumberFormatter *noCurrencyRateFormatter = [[NSThread currentThread] threadDictionary][noCurrencyRateKey];
    if (!noCurrencyRateFormatter) {
        noCurrencyRateFormatter = [[NSNumberFormatter alloc] init];
        [noCurrencyRateFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [noCurrencyRateFormatter setMinimumFractionDigits:2];
        [noCurrencyRateFormatter setMaximumFractionDigits:3];
        [noCurrencyRateFormatter setUsesGroupingSeparator:false];
        [[NSThread currentThread] threadDictionary][noCurrencyRateKey] = noCurrencyRateFormatter;
    }
    
    return [[noCurrencyRateFormatter stringFromNumber:amount] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)currencyFormattedPrice {
    return [self formattedMoneyString:self.amount];
}

- (NSString *)mileageRateCurrencyFormattedPrice {
    NSString *amount = [Price mileageRateAmountAsString:self.amount];
    NSString *currencySymbol = [[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencySymbol value:self.currency.code];
    return [NSString stringWithFormat:@"%@%@", currencySymbol, amount];
}

- (NSString *)formattedMoneyString:(NSDecimalNumber *)moneyAmount {
    return [[Price formatterForCurrencyCode:self.currency.code] stringFromNumber:moneyAmount];
}

+ (NSNumberFormatter *)formatterForCurrencyCode:(NSString *)code {
    NSNumberFormatter *formatter = [[NSThread currentThread] threadDictionary][code];
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMinimumFractionDigits:2];
        [formatter setMaximumFractionDigits:2];
        [formatter setCurrencyCode:code];
        [[NSThread currentThread] threadDictionary][code] = formatter;
    }

    return formatter;
}

@end
