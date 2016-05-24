//
//  DatabaseTableNames.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseTableNames.h"

const struct TripsTableStruct TripsTable = {
        .TABLE_NAME = @"trips",
        .COLUMN_NAME = @"name",
        .COLUMN_FROM = @"from_date",
        .COLUMN_TO = @"to_date",
        .COLUMN_FROM_TIMEZONE = @"from_timezone",
        .COLUMN_TO_TIMEZONE = @"to_timezone",
        .COLUMN_PRICE = @"price", // Deprecated, since this is receipt info
        .COLUMN_MILEAGE = @"miles_new",
        .COLUMN_COMMENT = @"trips_comment",
        .COLUMN_COST_CENTER = @"trips_cost_center",
        .COLUMN_DEFAULT_CURRENCY = @"trips_default_currency",
        .COLUMN_FILTERS = @"trips_filters",
        .COLUMN_PROCESSING_STATUS = @"trip_processing_status"
};

const struct PaymentMethodsTableStruct PaymentMethodsTable = {
        .TABLE_NAME = @"paymentmethods",
        .COLUMN_ID = @"id",
        .COLUMN_METHOD = @"method"
};


const struct ReceiptsTableStruct ReceiptsTable = {
        .TABLE_NAME = @"receipts",
        .COLUMN_ID = @"id",
        .COLUMN_PATH = @"path",
        .COLUMN_NAME = @"name",
        .COLUMN_PARENT = @"parent",
        .COLUMN_CATEGORY = @"category",
        .COLUMN_PRICE = @"price",
        .COLUMN_TAX = @"tax",
        .COLUMN_PAYMENTMETHOD = @"paymentmethod", // Deprecated
        .COLUMN_DATE = @"rcpt_date",
        .COLUMN_TIMEZONE = @"timezone",
        .COLUMN_COMMENT = @"comment",
        .COLUMN_EXPENSEABLE = @"expenseable",
        .COLUMN_ISO4217 = @"isocode",
        .COLUMN_PAYMENT_METHOD_ID = @"paymentMethodKey",
        .COLUMN_NOTFULLPAGEIMAGE = @"fullpageimage",
        .COLUMN_PROCESSING_STATUS = @"receipt_processing_status",
        .COLUMN_EXTRA_EDITTEXT_1 = @"extra_edittext_1",
        .COLUMN_EXTRA_EDITTEXT_2 = @"extra_edittext_2",
        .COLUMN_EXTRA_EDITTEXT_3 = @"extra_edittext_3",
        .COLUMN_EXCHANGE_RATE = @"exchange_rate"
};

const struct DistanceTableStruct DistanceTable = {
        .TABLE_NAME = @"distance",
        .COLUMN_ID = @"id",
        .COLUMN_PARENT = @"parent",
        .COLUMN_DISTANCE = @"distance",
        .COLUMN_LOCATION = @"location",
        .COLUMN_DATE = @"date",
        .COLUMN_TIMEZONE = @"timezone",
        .COLUMN_COMMENT = @"comment",
        .COLUMN_RATE = @"rate",
        .COLUMN_RATE_CURRENCY = @"rate_currency"
};

const struct CategoriesTableStruct CategoriesTable = {
        .TABLE_NAME = @"categories",
        .COLUMN_NAME = @"name",
        .COLUMN_CODE = @"code",
        .COLUMN_BREAKDOWN = @"breakdown"
};

const struct CSVTableStruct CSVTable = {
        .TABLE_NAME = @"csvcolumns",
        .COLUMN_ID = @"id",
        .COLUMN_TYPE = @"type"
};

const struct PDFTableStruct PDFTable = {
        .TABLE_NAME = @"pdfcolumns",
        .COLUMN_ID = @"id",
        .COLUMN_TYPE = @"type"
};
