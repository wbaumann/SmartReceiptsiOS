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

- (id)initWithId:(NSUInteger) objectId method:(NSString *)method {
    self = [super init];
    if (self) {
        _objectId = objectId;
        _method = method;
    }
    return self;
}

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
    return [self.method isEqualToString:otherMethod.method];
}

- (NSUInteger)hash {
    return self.method.hash;
}

- (NSString *)presentedValue {
    return self.method;
}

@end
