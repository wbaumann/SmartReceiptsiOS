//
//  TaxCalculator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TaxCalculator.h"
#import "NSDecimalNumber+WBNumberParse.h"

@interface TaxCalculator ()

@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UITextField *taxField;
@property (nonatomic, strong) NSNumberFormatter *taxFormatter;

@end

@implementation TaxCalculator

- (id)initWithSourceField:(UITextField *)priceField targetField:(UITextField *)taxField {
    self = [super init];
    if (self) {
        _priceField = priceField;
        _taxField = taxField;
        [priceField addTarget:self action:@selector(priceChanged) forControlEvents:UIControlEventEditingChanged];
        _taxFormatter = [[NSNumberFormatter alloc] init];
        [_taxFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_taxFormatter setCurrencySymbol:@""];
        [_taxFormatter setCurrencyGroupingSeparator:@""];
    }
    return self;
}

- (void)priceChanged {
    NSString *priceString = self.priceField.text;
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:priceString];
    NSDecimalNumber *tax = [TaxCalculator taxWithPrice:price taxPercentage:self.taxPercentage priceEnteredPreTax:self.priceIsPreTax];
    [self.taxField setText:[self.taxFormatter stringFromNumber:tax]];
}

static NSDecimalNumber *__hundred;
+ (NSDecimalNumber *)hundred {
    if (!__hundred) {
        __hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    }

    return __hundred;
}

+ (NSDecimalNumber *)taxWithPrice:(NSDecimalNumber *)price taxPercentage:(NSDecimalNumber *)taxPercentage priceEnteredPreTax:(BOOL)preTax {
    NSDecimalNumber *tax;
    if (preTax) {
        tax = [[price decimalNumberByMultiplyingBy:taxPercentage] decimalNumberByDividingBy:self.hundred];
    } else {
        NSDecimalNumber *addeage = [self.hundred decimalNumberByAdding:taxPercentage];
        NSDecimalNumber *divided = [price decimalNumberByDividingBy:addeage];
        tax = [divided decimalNumberByMultiplyingBy:taxPercentage];
    }

    return tax;
}

@end
