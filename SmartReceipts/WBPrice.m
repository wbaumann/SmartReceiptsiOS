//
//  WBPrice.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "WBPrice.h"
#import "WBCurrency.h"
#import "Constants.h"

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
    return [[WBPrice formatterForCurrencyCode:self.currency.code] stringFromNumber:moneyAmount];
}

+ (NSNumberFormatter *)formatterForCurrencyCode:(NSString *)code {
    NSNumberFormatter *formatter = [WBPrice sharedFormatterCache][code];
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:code];
        [WBPrice sharedFormatterCache][code] = formatter;
    }

    return formatter;
}

+ (NSMutableDictionary *)sharedFormatterCache {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[NSMutableDictionary alloc] init];
    });
}

@end
