//
//  PaymentMethod.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMResultSet.h>
#import "PaymentMethod.h"
#import "DatabaseTableNames.h"

@interface PaymentMethod ()

@property (nonatomic, assign) NSUInteger objectId;
@property (nonatomic, copy) NSString *method;

@end

@implementation PaymentMethod

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    [self setObjectId:(NSUInteger) [resultSet intForColumn:PaymentMethodsTable.COLUMN_ID]];
    [self setMethod:[resultSet stringForColumn:PaymentMethodsTable.COLUMN_METHOD]];
}

@end
