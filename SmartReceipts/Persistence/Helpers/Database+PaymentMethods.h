//
//  Database+PaymentMethods.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class FetchedModelAdapter;
@class PaymentMethod;

@interface Database (PaymentMethods)

- (BOOL)createPaymentMethodsTable;
- (FetchedModelAdapter *)fetchedAdapterForPaymentMethods;
- (BOOL)savePaymentMethod:(PaymentMethod *)method;
- (BOOL)updatePaymentMethod:(PaymentMethod *)method;
- (BOOL)deletePaymentMethod:(PaymentMethod *)method;
- (NSArray<PaymentMethod *> *)allPaymentMethods;
- (PaymentMethod *)paymentMethodById:(NSUInteger)methodId;
- (PaymentMethod *)paymentMethodByName:(NSString *)name;
- (BOOL)hasPaymentMethodWithName:(NSString *)name;
- (NSArray<NSString *> *)allPaymentMethodsAsStrings;
- (BOOL)hasPaymentMethodCustomOrderIdColumn;

@end
