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

@end

@implementation PaymentMethod

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    [self setObjectId:(NSUInteger) [resultSet intForColumn:PaymentMethodsTable.COLUMN_ID]];
    [self setMethod:[resultSet stringForColumn:PaymentMethodsTable.COLUMN_METHOD]];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    PaymentMethod *otherMethod = other;
    return self.objectId == otherMethod.objectId;
}

- (NSUInteger)hash {
    return @(self.objectId).hash;
}

@end
