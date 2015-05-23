//
//  TaxCalculatorTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TaxCalculator.h"
#import "NSDecimalNumber+WBNumberParse.h"

@interface TaxCalculator(TestExpose)

+ (NSDecimalNumber *)taxWithPrice:(NSDecimalNumber *)price taxPercentage:(NSDecimalNumber *)taxPercentage priceEnteredPreTax:(BOOL)preTax;

@end

@interface TaxCalculatorTest : XCTestCase

@property (nonatomic, strong) NSDecimalNumber *tax20;

@end

@implementation TaxCalculatorTest

- (void)setUp {
    [super setUp];

    self.tax20 = [NSDecimalNumber decimalNumberOrZero:@"20"];
}

- (void)testPriceWithoutTax {
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberOrZero:@"20"];
    NSDecimalNumber *tax = [TaxCalculator taxWithPrice:[NSDecimalNumber decimalNumberOrZero:@"100"] taxPercentage:self.tax20 priceEnteredPreTax:YES];
    XCTAssertEqualObjects(expected, tax);
}

- (void)testPriceWithTax {
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberOrZero:@"20"];
    NSDecimalNumber *tax = [TaxCalculator taxWithPrice:[NSDecimalNumber decimalNumberOrZero:@"120"] taxPercentage:self.tax20 priceEnteredPreTax:NO];
    XCTAssertEqualObjects(expected, tax);
}

@end
