//
//  WBReceipt+Query.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

@objc
extension WBReceipt {
    
    class func selectAllQueryForTrip(_ trip: WBTrip?) -> DatabaseQueryBuilder {
        return self.selectAllQueryForTrip(trip, isAscending: false)
    }
    
    class func selectAllQueryForTrip(_ trip: WBTrip?, isAscending: Bool) -> DatabaseQueryBuilder {
        let whereTrip = trip != nil ? " WHERE \(ReceiptsTable.Column.Parent) = \"\(trip!.name!)\"" : ""
        return selectQuery(condition: whereTrip, isAscending: isAscending)
    }
    
    class func selectByObjectID(_ objectID: UInt) -> DatabaseQueryBuilder {
        let condition = " WHERE \(ReceiptsTable.Column.Id) = \"\(objectID)\""
        return selectQuery(condition: condition, isAscending: false)
    }
    
    class func selectAllUnmarkedForDeletion(_ trip: WBTrip) -> DatabaseQueryBuilder {
        var condition = " WHERE \(ReceiptsTable.Column.Parent) = \"\(trip.name!)\""
        condition += " AND \(SyncStateColumns.MarkedForDeletion) = 0"
        return selectQuery(condition: condition, isAscending: false)
    }
    
    class func selectAllMarkedForDeletion() -> DatabaseQueryBuilder {
        let condition = " WHERE \(SyncStateColumns.MarkedForDeletion) = 1"
        return selectQuery(condition: condition, isAscending: false)
    }
    
    class func selectAllUnsynced() -> DatabaseQueryBuilder {
        let condition = " WHERE \(SyncStateColumns.IsSynced) = 0"
        return selectQuery(condition: condition, isAscending: false)
    }
    
    fileprivate class func selectQuery(condition: String, isAscending: Bool) -> DatabaseQueryBuilder {
        let paymentMethodIdAsName = "\(PaymentMethodsTable.Name)_\(PaymentMethodsTable.Column.Id)"
        let paymentMethodCustomOrderIdName = "\(PaymentMethodsTable.Name)_\(PaymentMethodsTable.Column.CustomOrderId)"
        let categoryIdAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Id)"
        let categoryCodeAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Code)"
        let categoryNameAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Name)"
        let categoryCustomOrderIdAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.CustomOrderId)"
        
        let ascending = isAscending ? "ASC" : "DESC"
        
        let query = "SELECT * FROM \(ReceiptsTable.Name) AS RCPTS" +
            " LEFT JOIN (SELECT \(PaymentMethodsTable.Column.Method), \(PaymentMethodsTable.Column.Id) AS \(paymentMethodIdAsName)," +
            " \(PaymentMethodsTable.Column.CustomOrderId) AS \(paymentMethodCustomOrderIdName)" +
            " FROM \(PaymentMethodsTable.Name)) AS PM" +
            " ON RCPTS.\(ReceiptsTable.Column.PaymentMethodId) = PM.\(paymentMethodIdAsName)" +
            " LEFT JOIN (SELECT \(CategoriesTable.Column.Name) AS \(categoryNameAsName)," +
            " \(CategoriesTable.Column.Code) AS \(categoryCodeAsName)," +
            " \(CategoriesTable.Column.Id) AS \(categoryIdAsName)," +
            " \(CategoriesTable.Column.CustomOrderId) AS \(categoryCustomOrderIdAsName) FROM \(CategoriesTable.Name)) AS CATS" +
            " ON RCPTS.\(ReceiptsTable.Column.CategoryId) = CATS.\(categoryIdAsName)" +
            condition + " ORDER BY \(CategoriesTable.Column.CustomOrderId) \(ascending)"
        
        return DatabaseQueryBuilder.rawQuery(query)
    }
}
