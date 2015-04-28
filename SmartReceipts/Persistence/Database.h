//
//  Database.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

struct TripsTableStruct {
    __unsafe_unretained NSString *const TABLE_NAME;
    __unsafe_unretained NSString *const COLUMN_NAME;
    __unsafe_unretained NSString *const COLUMN_FROM;
    __unsafe_unretained NSString *const COLUMN_TO;
    __unsafe_unretained NSString *const COLUMN_FROM_TIMEZONE;
    __unsafe_unretained NSString *const COLUMN_TO_TIMEZONE;
    __unsafe_unretained NSString *const COLUMN_PRICE; // Deprecated, since this is receipt info
    __unsafe_unretained NSString *const COLUMN_MILEAGE;
    __unsafe_unretained NSString *const COLUMN_COMMENT;
    __unsafe_unretained NSString *const COLUMN_COST_CENTER;
    __unsafe_unretained NSString *const COLUMN_DEFAULT_CURRENCY;
    __unsafe_unretained NSString *const COLUMN_FILTERS;
    __unsafe_unretained NSString *const COLUMN_PROCESSING_STATUS;
};
extern const struct TripsTableStruct TripsTable;

struct PaymentMethodsTableStruct {
    __unsafe_unretained NSString *const TABLE_NAME;
    __unsafe_unretained NSString *const COLUMN_ID;
    __unsafe_unretained NSString *const COLUMN_METHOD;
};
extern const struct PaymentMethodsTableStruct PaymentMethodsTable;

struct  ReceiptsTableStruct {
    __unsafe_unretained NSString *const TABLE_NAME;
    __unsafe_unretained NSString *const COLUMN_ID;
    __unsafe_unretained NSString *const COLUMN_PATH;
    __unsafe_unretained NSString *const COLUMN_NAME;
    __unsafe_unretained NSString *const COLUMN_PARENT;
    __unsafe_unretained NSString *const COLUMN_CATEGORY;
    __unsafe_unretained NSString *const COLUMN_PRICE;
    __unsafe_unretained NSString *const COLUMN_TAX;
    __unsafe_unretained NSString *const COLUMN_DATE;
    __unsafe_unretained NSString *const COLUMN_TIMEZONE;
    __unsafe_unretained NSString *const COLUMN_COMMENT;
    __unsafe_unretained NSString *const COLUMN_EXPENSEABLE;
    __unsafe_unretained NSString *const COLUMN_ISO4217;
    __unsafe_unretained NSString *const COLUMN_PAYMENT_METHOD_ID;
    __unsafe_unretained NSString *const COLUMN_NOTFULLPAGEIMAGE;
    __unsafe_unretained NSString *const COLUMN_PROCESSING_STATUS;
    __unsafe_unretained NSString *const COLUMN_EXTRA_EDITTEXT_1;
    __unsafe_unretained NSString *const COLUMN_EXTRA_EDITTEXT_2;
    __unsafe_unretained NSString *const COLUMN_EXTRA_EDITTEXT_3;
};
extern const struct ReceiptsTableStruct ReceiptsTable;

struct DistanceTableStruct {
    __unsafe_unretained NSString *const TABLE_NAME;
    __unsafe_unretained NSString *const COLUMN_ID;
    __unsafe_unretained NSString *const COLUMN_PARENT;
    __unsafe_unretained NSString *const COLUMN_DISTANCE;
    __unsafe_unretained NSString *const COLUMN_LOCATION;
    __unsafe_unretained NSString *const COLUMN_DATE;
    __unsafe_unretained NSString *const COLUMN_TIMEZONE;
    __unsafe_unretained NSString *const COLUMN_COMMENT;
    __unsafe_unretained NSString *const COLUMN_RATE;
    __unsafe_unretained NSString *const COLUMN_RATE_CURRENCY;
};
extern const struct DistanceTableStruct DistanceTable;

@interface Database : NSObject

@end
