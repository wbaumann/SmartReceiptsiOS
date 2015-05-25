//
//  PricesCollection.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PricesCollection.h"
#import "WBCurrency.h"
#import "NSDecimalNumber+WBNumberParse.h"

@interface PricesCollection ()

@property (nonatomic, strong) NSMutableDictionary *totals;
@property (nonatomic, strong) NSDecimalNumber *minusOne;

@end

@implementation PricesCollection

- (instancetype)init {
    self = [super init];
    if (self) {
        _totals = [NSMutableDictionary dictionary];
        _minusOne = [NSDecimalNumber decimalNumberOrZero:@"-1"];
    }

    return self;
}


- (void)addPrice:(Price *)price {
    [self addAmount:price.amount withCurrency:price.currency.code];
}

- (void)subtractPrice:(Price *)price {
    [self addAmount:[price.amount decimalNumberByMultiplyingBy:self.minusOne] withCurrency:price.currency.code];
}

- (BOOL)hasValue {
    NSArray *allValues = self.totals.allValues;
    for (NSDecimalNumber *value in allValues) {
        if (![value isEqualToNumber:[NSDecimalNumber zero]]) {
            return YES;
        }
    }
    return NO;
}

- (void)addAmount:(NSDecimalNumber *)amount withCurrency:(NSString *)currency {
    NSDecimalNumber *total = self.totals[currency];
    if (!total) {
        total = [NSDecimalNumber zero];
    }

    total = [total decimalNumberByAdding:amount];
    self.totals[currency] = total;
}

- (NSString *)currencyFormattedPrice {
    NSArray *codes = [self.totals.keyEnumerator.allObjects sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *differentFormats = [NSMutableArray arrayWithCapacity:self.totals.count];
    for (NSString *code in codes) {
        NSDecimalNumber *amount = self.totals[code];
        Price *price = [Price priceWithAmount:amount currencyCode:code];
        [differentFormats addObject:price.currencyFormattedPrice];
    }

    return [differentFormats componentsJoinedByString:@"; "];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    PricesCollection *collection = other;
    return [self.currencyFormattedPrice isEqualToString:collection.currencyFormattedPrice];
}

- (NSUInteger)hash {
    return [self.currencyFormattedPrice hash];
}

@end
