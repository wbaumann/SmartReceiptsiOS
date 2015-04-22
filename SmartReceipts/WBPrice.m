//
//  WBPrice.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "WBPrice.h"
#import "WBCurrency.h"

@interface WBPrice ()

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) WBCurrency *currency;

@end

@implementation WBPrice

+ (WBPrice *)priceWithAmount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode {
    WBPrice *price = [[WBPrice alloc] init];
    [price setAmount:amount];
    [price setCurrency:[WBCurrency currencyForCode:currencyCode]];
    return price;
}

+ (WBPrice *)zeroPriceWithCurrencyCode:(NSString *)currencyCode {
    return [WBPrice priceWithAmount:[NSDecimalNumber zero] currencyCode:currencyCode];
}

- (NSString *)amountAsString {
    static NSString const *noCurrencyKey = @"noCurrencyFormatter";
    NSNumberFormatter *noCurrencyFormatter = [[NSThread currentThread] threadDictionary][noCurrencyKey];
    if (!noCurrencyFormatter) {
        noCurrencyFormatter = [[NSNumberFormatter alloc] init];
        [noCurrencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [noCurrencyFormatter setCurrencySymbol:@""];
        [noCurrencyFormatter setGroupingSeparator:@""];
        [[NSThread currentThread] threadDictionary][noCurrencyKey] = noCurrencyFormatter;
    }

    return [[noCurrencyFormatter stringFromNumber:self.amount] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)currencyFormattedPrice {
    return [self formattedMoneyString:self.amount];
}

- (NSString *)formattedMoneyString:(NSDecimalNumber *)moneyAmount {
    return [[WBPrice formatterForCurrencyCode:self.currency.code] stringFromNumber:moneyAmount];
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
