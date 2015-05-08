//
//  DatabaseTestsHelper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseTestsHelper.h"
#import "WBTrip.h"
#import "Distance.h"
#import "WBPrice.h"
#import "Database+Distances.h"
#import "Database+Trips.h"
#import "WBReceipt.h"
#import "DatabaseTableNames.h"
#import "Database+Receipts.h"

@interface Distance (TestExpose)

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment;

@end

@implementation DatabaseTestsHelper

- (WBTrip *)createTestTrip {
    return [self insertTrip:@{}];
}

- (WBTrip *)insertTrip:(NSDictionary *)modifiedParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = [NSString stringWithFormat:@"TestTrip - %f", [NSDate timeIntervalSinceReferenceDate]];
    [params addEntriesFromDictionary:modifiedParams];

    WBTrip *trip = [[WBTrip alloc] initWithName:params[@"name"] startDate:[NSDate date] endDate:[NSDate date] currencyCode:@"USD"];
    [self saveTrip:trip];
    return trip;
}

- (void)insertDistance:(NSDictionary *)modifiedParams {
    NSMutableDictionary *defaultParams = [NSMutableDictionary dictionary];
    defaultParams[@"location"] = @"Test location";
    defaultParams[@"trip"] = [self createTestTrip];
    defaultParams[@"date"] = [NSDate date];

    [defaultParams addEntriesFromDictionary:modifiedParams];

    NSDictionary *params = [NSDictionary dictionaryWithDictionary:defaultParams];

    Distance *distance = [[Distance alloc] initWithTrip:params[@"trip"]
                                               distance:[NSDecimalNumber decimalNumberWithString:@"10"]
                                                   rate:[WBPrice priceWithAmount:[NSDecimalNumber decimalNumberWithString:@"12"] currencyCode:@"USD"]
                                               location:params[@"location"]
                                                   date:params[@"date"]
                                               timeZone:[NSTimeZone defaultTimeZone]
                                                comment:@"Comment"];
    [self saveDistance:distance];
}

- (void)insertReceipt:(NSDictionary *)modifiedParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ReceiptsTable.COLUMN_NAME] = [NSString stringWithFormat:@"TestReceipt - %f", [NSDate timeIntervalSinceReferenceDate]];
    params[ReceiptsTable.COLUMN_PARENT] = [self createTestTrip];
    params[ReceiptsTable.COLUMN_PRICE] = [NSDecimalNumber decimalNumberWithString:@"20"];
    params[ReceiptsTable.COLUMN_EXPENSEABLE] = @(YES);

    [params addEntriesFromDictionary:modifiedParams];

    WBReceipt *receipt = [[WBReceipt alloc] initWithId:NSNotFound
                                                  name:params[ReceiptsTable.COLUMN_NAME]
                                              category:@""
                                         imageFileName:@""
                                                dateMs:0
                                          timeZoneName:[NSTimeZone localTimeZone].name
                                               comment:@""
                                                 price:[WBPrice priceWithAmount:params[ReceiptsTable.COLUMN_PRICE] currencyCode:@"USD"]
                                                   tax:[WBPrice zeroPriceWithCurrencyCode:@"USD"]
                                          isExpensable:[params[ReceiptsTable.COLUMN_EXPENSEABLE] boolValue]
                                            isFullPage:0
                                        extraEditText1:@""
                                        extraEditText2:@""
                                        extraEditText3:@""];
    [receipt setTrip:params[ReceiptsTable.COLUMN_PARENT]];
    [self saveReceipt:receipt];
}

@end
