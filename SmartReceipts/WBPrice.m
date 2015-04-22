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

static NSNumberFormatter *__noCurrencyFormatter;
- (NSString *)amountAsString {
    if (!__noCurrencyFormatter) {
        __noCurrencyFormatter = [[NSNumberFormatter alloc] init];
        [__noCurrencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [__noCurrencyFormatter setCurrencySymbol:@""];
        [__noCurrencyFormatter setGroupingSeparator:@""];
    }

    return [[__noCurrencyFormatter stringFromNumber:self.amount] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)currencyFormattedPrice {
    return [self formattedMoneyString:self.amount];
}

- (NSString *)formattedMoneyString:(NSDecimalNumber *)moneyAmount {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencyCode:[self.currency code]];
    return [currencyFormatter stringFromNumber:moneyAmount];
}

@end
