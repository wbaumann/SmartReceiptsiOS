//
//  ReportGeneratorTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WBTrip.h"
#import "WBDB.h"
#import "WBPrice.h"
#import "ReportGenerator.h"
#import "WBPreferences.h"

@interface ReportGeneratorTest : XCTestCase

@property (nonatomic, strong) WBTrip *testTrip;

@end

@implementation ReportGeneratorTest

- (void)setUp {
    self.testTrip = [[WBDB trips] insertWithName:@"TEST XYZZZZZZZZZ" from:[NSDate date] to:[NSDate date]];
    [WBPreferences setMinimumReceiptPriceToIncludeInReports:0];
}

- (void)tearDown {
    [[WBDB trips] deleteWithName:self.testTrip.name];
}

- (void)testReceiptsProvidedHaveTripObject {
    [self createTestReceipt:1];
    [self createTestReceipt:2];
    [self createTestReceipt:3];
    
    ReportGenerator *generator = [[ReportGenerator alloc] initWithTrip:self.testTrip];
    NSArray *receipts = [generator receipts];
    XCTAssertEqual(3, receipts.count);
    for (WBReceipt *receipt in receipts) {
        XCTAssertNotNil(receipt.trip);
    }
}

- (void)createTestReceipt:(NSInteger)marker {
    [[WBDB receipts] insertWithTrip:self.testTrip
                               name:[NSString stringWithFormat:@"TEST Receipt %li", marker]
                           category:@""
                      imageFileName:@""
                             dateMs:0
                       timeZoneName:@""
                            comment:@""
                              price:[WBPrice priceWithAmount:[NSDecimalNumber decimalNumberWithString:@"11"] currencyCode:@"USD"]
                                tax:nil
                       isExpensable:YES
                         isFullPage:YES
                     extraEditText1:@""
                     extraEditText2:@""
                     extraEditText3:@""];
}

@end
