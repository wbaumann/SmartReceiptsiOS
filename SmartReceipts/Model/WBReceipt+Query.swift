//
//  WBReceipt+Query.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension WBReceipt {
    
    
    class func selectAllQueryForTrip(_ trip: WBTrip?) -> DatabaseQueryBuilder {
        return self.selectAllQueryForTrip(trip, isAscending: false)
    }
    
    class func selectAllQueryForTrip(_ trip: WBTrip?, isAscending: Bool) -> DatabaseQueryBuilder {
        
        let receiptIdFullName = "\(ReceiptsTable.Name).\(ReceiptsTable.Column.Id)"
        let receiptIdAsName = "\(ReceiptsTable.Name)_\(ReceiptsTable.Column.Id)"
        let receiptNameFullName = "\(ReceiptsTable.Name).\(ReceiptsTable.Column.Name)"
        let receiptNameAsName = "\(ReceiptsTable.Name)_\(ReceiptsTable.Column.Name)"
        
        let paymentMethodIdFullName = "\(PaymentMethodsTable.Name).\(PaymentMethodsTable.Column.Id)"
        let paymentMethodIdAsName = "\(PaymentMethodsTable.Name)_\(PaymentMethodsTable.Column.Id)"
        
        let categoryIdFullName = "\(CategoriesTable.Name).\(CategoriesTable.Column.Id)"
        let categoryIdAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Id)"
        let categoryCodeFullName = "\(CategoriesTable.Name).\(CategoriesTable.Column.Code)"
        let categoryCodeAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Code)"
        let categoryNameFullName = "\(CategoriesTable.Name).\(CategoriesTable.Column.Name)"
        let categoryNameAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Name)"
        let categoryCustomOrderIdFullName = "\(CategoriesTable.Name).\(CategoriesTable.Column.CustomOrderId)"
        let categoryCustomOrderIdAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.CustomOrderId)"
        
        
        let selectAll = DatabaseQueryBuilder.selectAllStatement(forTable: ReceiptsTable.Name)
        if let trip = trip {
            selectAll?.`where`(ReceiptsTable.Column.Parent, value: trip.name.asNSString)
        }
        selectAll?.select(receiptIdFullName, as: receiptIdAsName)
        selectAll?.select(receiptNameFullName, as: receiptNameAsName)
        
        selectAll?.select(paymentMethodIdFullName, as: paymentMethodIdAsName)
        
        selectAll?.select(categoryIdFullName, as: categoryIdAsName)
        selectAll?.select(categoryCodeFullName, as: categoryCodeAsName)
        selectAll?.select(categoryNameFullName, as: categoryNameAsName)
        selectAll?.select(categoryCustomOrderIdFullName, as: categoryCustomOrderIdAsName)

        
        selectAll?.leftJoin(PaymentMethodsTable.Name, on: ReceiptsTable.Column.PaymentMethodId.asNSString, equalTo: PaymentMethodsTable.Column.Id.asNSString)
        selectAll?.leftJoin(CategoriesTable.Name, on: ReceiptsTable.Column.CategoryId.asNSString, equalTo: CategoriesTable.Column.Id.asNSString)
    
        selectAll?.order(by: ReceiptsTable.Column.Date, ascending: isAscending)
        
        return selectAll!
    }
}
