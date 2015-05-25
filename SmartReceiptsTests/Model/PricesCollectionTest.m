//
//  PricesCollectionTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PricesCollection.h"
#import "NSDecimalNumber+WBNumberParse.h"

@interface PricesCollectionTest : XCTestCase

@property (nonatomic, strong) PricesCollection *collection;

@end

@implementation PricesCollectionTest

- (void)setUp {
    [super setUp];

    self.collection = [[PricesCollection alloc] init];
}

- (void)testSingleCurrencyAdd {
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"10"] currencyCode:@"USD"]];
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"20"] currencyCode:@"USD"]];
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"30"] currencyCode:@"USD"]];

    Price *expected = [Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"60"] currencyCode:@"USD"];
    XCTAssertEqualObjects(expected.currencyFormattedPrice, self.collection.currencyFormattedPrice);
}

- (void)testSingleCurrencyAddRemove {
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"10"] currencyCode:@"USD"]];
    [self.collection subtractPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"5"] currencyCode:@"USD"]];
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"20"] currencyCode:@"USD"]];
    [self.collection subtractPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"10"] currencyCode:@"USD"]];

    Price *expected = [Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"15"] currencyCode:@"USD"];
    XCTAssertEqualObjects(expected.currencyFormattedPrice, self.collection.currencyFormattedPrice);
}

- (void)testMultiCurrencyAdd {
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"10"] currencyCode:@"USD"]];
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"20"] currencyCode:@"EUR"]];
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"30"] currencyCode:@"USD"]];
    [self.collection addPrice:[Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"40"] currencyCode:@"EUR"]];

    Price *expectedEUR = [Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"60"] currencyCode:@"EUR"];
    Price *expectedUSD = [Price priceWithAmount:[NSDecimalNumber decimalNumberOrZero:@"40"] currencyCode:@"USD"];
    NSString *expectedResult = [@[expectedEUR.currencyFormattedPrice, expectedUSD.currencyFormattedPrice] componentsJoinedByString:@"; "];
    XCTAssertEqualObjects(expectedResult, self.collection.currencyFormattedPrice);
}

@end
