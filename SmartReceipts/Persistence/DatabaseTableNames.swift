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
        static let Parent = "parent"
        static let Category = "category"
        static let Price = "price"
        static let Tax = "tax"
        static let Date = "rcpt_date"
        static let Timezone = "timezone"
        static let Comment = "comment"
        static let Expenseable = "expenseable"
        static let ISO4217 = "isocode"
        static let PaymentMethodId = "paymentMethodKey"
        static let NotFullPageImage = "fullpageimage"
        static let ProcessingStatus = "receipt_processing_status"
        static let ExtraEditText1 = "extra_edittext_1"
        static let ExtraEditText2 = "extra_edittext_2"
        static let ExtraEditText3 = "extra_edittext_3"

        
        @available(*, unavailable, message="paymentmethod is deprecated, use paymentMethodKey")
        static let PaymentMethod = "paymentmethod"
    }
}

enum CategoriesTable {
    static let Name = "categories"
    
    enum Column {
        static let Name = "name"
        static let code = "code"
        static let Breakdown = "breakdown"
    }
}
