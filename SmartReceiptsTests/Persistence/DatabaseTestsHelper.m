//
//  DatabaseTestsHelper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseTestsHelper.h"
#import "WBTrip.h"
#import "Price.h"
#import "Database+Distances.h"
#import "Database+Trips.h"
#import "WBReceipt.h"
#import "DatabaseTableNames.h"
#import "Database+Receipts.h"
#import "NSString+Validation.h"
#import "PaymentMethod.h"
#import "Database+PaymentMethods.h"
#import "Database+Functions.h"
#import "DatabaseQueryBuilder.h"
#import "NSDate+Calculations.h"
#import "Database+PDFColumns.h"
#import <SmartReceipts-Swift.h>

@interface Database (Expose)

- (WBTrip *)tripWithName:(NSString *)name;

@end

@interface Distance (TestExpose)

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(Price *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment;
- (WBTrip *)tripWithName:(NSString *)name;

@end

@implementation DatabaseTestsHelper

- (WBTrip *)createTestTrip {
    return [self insertTestTrip:@{}];
}

- (WBTrip *)insertTestTrip:(NSDictionary *)modifiedParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[TripsTable.COLUMN_NAME] = [NSString stringWithFormat:@"TestTrip - %@", [NSDate date].milliseconds];
    params[TripsTable.COLUMN_FROM] = [NSDate date];
    params[TripsTable.COLUMN_TO] = [NSDate date];
    params[TripsTable.COLUMN_DEFAULT_CURRENCY] = @"USD";
    [params addEntriesFromDictionary:modifiedParams];

    WBTrip *trip = [[WBTrip alloc] init];
    [trip setName:params[TripsTable.COLUMN_NAME]];
    [trip setStartDate:params[TripsTable.COLUMN_FROM]];
    [trip setEndDate:params[TripsTable.COLUMN_TO]];
    [trip setDefaultCurrency:[Currency currencyForCode:params[TripsTable.COLUMN_DEFAULT_CURRENCY]]];
    [trip setComment:params[TripsTable.COLUMN_COMMENT]];
    [trip setCostCenter:params[TripsTable.COLUMN_COST_CENTER]];

    [self saveTrip:trip];
    return trip;
}

- (void)insertTestPaymentMethod:(NSString *)name {
    name = [name hasValue] ? name : [NSString stringWithFormat:@"TestMethod - %@", [NSDate date].milliseconds];
    PaymentMethod *method = [[PaymentMethod alloc] init];
    [method setMethod:name];
    [self savePaymentMethod:method];
}

- (Distance *)insertTestDistance:(NSDictionary *)modifiedParams {
    NSMutableDictionary *defaultParams = [NSMutableDictionary dictionary];
    defaultParams[DistanceTable.COLUMN_LOCATION] = @"Test location";
    defaultParams[DistanceTable.COLUMN_PARENT] = [self createTestTrip];
    defaultParams[DistanceTable.COLUMN_DATE] = [NSDate date];
    defaultParams[DistanceTable.COLUMN_DISTANCE] = [NSDecimalNumber decimalNumberWithString:@"10"];
    defaultParams[DistanceTable.COLUMN_RATE] = [NSDecimalNumber decimalNumberWithString:@"12"];
    defaultParams[DistanceTable.COLUMN_RATE_CURRENCY] = @"USD";

    [defaultParams addEntriesFromDictionary:modifiedParams];

    NSDictionary *params = [NSDictionary dictionaryWithDictionary:defaultParams];

    Distance *distance = [[Distance alloc] initWithTrip:params[DistanceTable.COLUMN_PARENT]
                                               distance:params[DistanceTable.COLUMN_DISTANCE]
                                                   rate:[Price priceWithAmount:params[DistanceTable.COLUMN_RATE] currencyCode:params[DistanceTable.COLUMN_RATE_CURRENCY]]
                                               location:params[DistanceTable.COLUMN_LOCATION]
                                                   date:params[DistanceTable.COLUMN_DATE]
                                               timeZone:[NSTimeZone defaultTimeZone]
                                                comment:@"Comment"];
    [self saveDistance:distance];
    return distance;
}

- (void)insertTestReceipt:(NSDictionary *)modifiedParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ReceiptsTable.COLUMN_NAME] = [NSString stringWithFormat:@"TestReceipt - %@", [NSDate date].milliseconds];
    params[ReceiptsTable.COLUMN_PRICE] = [NSDecimalNumber decimalNumberWithString:@"20"];
    params[ReceiptsTable.COLUMN_ISO4217] = @"USD";
    params[ReceiptsTable.COLUMN_REIMBURSABLE] = @(YES);
    params[ReceiptsTable.COLUMN_PATH] = [NSString stringWithFormat:@"TheFileOfDoom-%@", [NSDate date].milliseconds];
    params[ReceiptsTable.COLUMN_DATE] = [NSDate date];
    params[ReceiptsTable.COLUMN_PAYMENT_METHOD_ID] = [self allPaymentMethods].firstObject;
    params[ReceiptsTable.COLUMN_EXCHANGE_RATE] = [NSDecimalNumber decimalNumberWithString:@"-1"];

    [params addEntriesFromDictionary:modifiedParams];
    
    if (!params[ReceiptsTable.COLUMN_PARENT]) {
        params[ReceiptsTable.COLUMN_PARENT] = [self createTestTrip];
    }

    WBReceipt *receipt = [[WBReceipt alloc] init];
    [receipt setName:params[ReceiptsTable.COLUMN_NAME]];
    [receipt setTimeZone:[NSTimeZone localTimeZone]];
    [receipt setPrice:params[ReceiptsTable.COLUMN_PRICE] currency:params[ReceiptsTable.COLUMN_ISO4217]];
    [receipt setTax:[NSDecimalNumber zero]];
    [receipt setReimbursable:[params[ReceiptsTable.COLUMN_REIMBURSABLE] boolValue]];
    [receipt setTrip:params[ReceiptsTable.COLUMN_PARENT]];
    [receipt setPaymentMethod:params[ReceiptsTable.COLUMN_PAYMENT_METHOD_ID]];
    [receipt setImageFileName:params[ReceiptsTable.COLUMN_PATH]];
    [receipt setDate:params[ReceiptsTable.COLUMN_DATE]];
    [receipt setExchangeRate:params[ReceiptsTable.COLUMN_EXCHANGE_RATE]];

    [self saveReceipt:receipt];
}

- (WBReceipt *)receiptWithName:(NSString *)receiptName {
    NSString *receiptIdFullName = [NSString stringWithFormat:@"%@.%@", ReceiptsTable.TABLE_NAME, ReceiptsTable.COLUMN_ID];
    NSString *receiptIdAsName = [NSString stringWithFormat:@"%@_%@", ReceiptsTable.TABLE_NAME, ReceiptsTable.COLUMN_ID];
    NSString *paymentMethodIdFullName = [NSString stringWithFormat:@"%@.%@", PaymentMethodsTable.TABLE_NAME, PaymentMethodsTable.COLUMN_ID];
    NSString *paymentMethodIdAsName = [NSString stringWithFormat:@"%@_%@", PaymentMethodsTable.TABLE_NAME, PaymentMethodsTable.COLUMN_ID];

    DatabaseQueryBuilder *selectAll = [DatabaseQueryBuilder selectAllStatementForTable:ReceiptsTable.TABLE_NAME];
    [selectAll where:ReceiptsTable.COLUMN_NAME value:receiptName];
    [selectAll select:receiptIdFullName as:receiptIdAsName];
    [selectAll select:paymentMethodIdFullName as:paymentMethodIdAsName];
    [selectAll leftJoin:PaymentMethodsTable.TABLE_NAME on:ReceiptsTable.COLUMN_PAYMENT_METHOD_ID equalTo:PaymentMethodsTable.COLUMN_ID];

    WBReceipt *receipt = (WBReceipt *)[self executeFetchFor:[WBReceipt class] withQuery:selectAll];
    [receipt setTrip:[self tripWithName:receipt.tripName]];
    return receipt;
}

- (NSArray<WBReceipt *> *__nonnull)allReceipts {
    return [self allReceiptsForTrip:nil];
}

- (NSArray<ReceiptColumn *> *__nonnull)getPdfColumns {
    return [self allPDFColumns];
}

- (BOOL)setPdfColumns:(NSArray<ReceiptColumn *> *__nonnull)columns {
    return [self replaceAllPDFColumnsWith:columns];
}

@end
