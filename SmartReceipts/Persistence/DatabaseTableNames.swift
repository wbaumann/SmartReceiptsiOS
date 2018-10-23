//
//  DatabaseTableNames.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

// Currently it will mirror the other table names file. In future this should replace other one

enum ReceiptsTable {
    static let Name = "receipts"
    
    enum Column {
        static let Id = "id"
        static let Path = "path"
        static let Name = "name"
        static let ParentId = "parentKey"
        static let CategoryId = "categoryKey"
        static let Price = "price"
        static let Tax = "tax"
        static let ExchangeRate = "exchange_rate"
        static let Date = "rcpt_date"
        static let Timezone = "timezone"
        static let Comment = "comment"
        static let Reimbursable = "expenseable"
        static let ISO4217 = "isocode"
        static let PaymentMethodId = "paymentMethodKey"
        static let NotFullPageImage = "fullpageimage"
        static let ProcessingStatus = "receipt_processing_status"
        static let ExtraEditText1 = "extra_edittext_1"
        static let ExtraEditText2 = "extra_edittext_2"
        static let ExtraEditText3 = "extra_edittext_3"
        static let CustomOrderId = "custom_order_id"

        
        @available(*, unavailable, message: "paymentmethod is deprecated, use paymentMethodKey")
        static let PaymentMethod = "paymentmethod"
        
        @available(*, unavailable, message: "category is deprecated, use categoryKey")
        static let Category = "category"
    }
}

enum CategoriesTable {
    static let Name = "categories"
    
    enum Column {
        static let Name = "name"
        static let Id = "id"
        static let Code = "code"
        static let Breakdown = "breakdown"
        static let CustomOrderId = "custom_order_id"
    }
}

enum TripsTable {
    static let Name = "trips"
        
    enum Column {
        static let Id = "id"
        static let Name = "name"
        static let From = "from_date"
        static let To = "to_date"
        static let FromTimezone = "from_timezone"
        static let ToTimezone = "to_timezone"
        static let Mileage = "miles_new"
        static let Comment = "trips_comment"
        static let CostCenter = "trips_cost_center"
        static let DefaultCurrency = "trips_default_currency"
        static let Filters = "trips_filters"
        static let ProcessingStatus = "trip_processing_status"
        
        @available(*, unavailable)
        static let Price = "price"
    }
}

enum DistanceTable {
    static let Name = "distance"
        
    enum Column {
        static let Id = "id"
        static let ParentId = "parentKey"
        static let Distance = "distance"
        static let Location = "location"
        static let Date = "date"
        static let Timezone = "timezone"
        static let Comment = "comment"
        static let Rate = "rate"
        static let RateCurrency = "rate_currency"
    }
}

enum PaymentMethodsTable {
    static let Name = "paymentmethods"
        
    enum  Column {
        static let Id = "id"
        static let Method = "method"
        static let CustomOrderId = "custom_order_id"
    }
}

enum PDFColumnTable {
    static let Name = "pdfcolumns"
    
    enum  Column {
        static let Id = "id"
        static let `Type` = "type"
        static let CustomOrderId = "custom_order_id"
        static let ColumnType = "column_type"
    }
}

enum CSVColumnTable {
    static let Name = "csvcolumns"
    
    enum  Column {
        static let Id = "id"
        static let `Type` = "type"
        static let CustomOrderId = "custom_order_id"
        static let ColumnType = "column_type"
    }
}

enum SyncStateColumns {
    static let Id = "drive_sync_id"
    static let IsSynced = "drive_is_synced"
    static let MarkedForDeletion = "drive_marked_for_deletion"
    static let LastLocalModificationTime = "last_local_modification_time"
}
