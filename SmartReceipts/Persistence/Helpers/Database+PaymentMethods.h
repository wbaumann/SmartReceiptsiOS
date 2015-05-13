//
//  Database+PaymentMethods.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class FetchedModelAdapter;

@interface Database (PaymentMethods)

- (BOOL)createPaymentMethodsTable;
- (FetchedModelAdapter *)fetchedAdapterForPaymentMethods;

@end
