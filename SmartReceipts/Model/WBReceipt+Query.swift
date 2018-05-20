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
        let paymentMethodIdAsName = "\(PaymentMethodsTable.Name)_\(PaymentMethodsTable.Column.Id)"
        let categoryIdAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Id)"
        let categoryCodeAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Code)"
        let categoryNameAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.Name)"
        let categoryCustomOrderIdAsName = "\(CategoriesTable.Name)_\(CategoriesTable.Column.CustomOrderId)"
        
        let ascending = isAscending ? "ASC" : "DESC"
        
        let whereTrip = trip != nil ? " WHERE \(ReceiptsTable.Column.Parent) = \"\(trip!.name!)\"" : ""
        
        let query = "SELECT * FROM \(ReceiptsTable.Name) AS RCPTS" +
            " LEFT JOIN (SELECT \(PaymentMethodsTable.Column.Method), \(PaymentMethodsTable.Column.Id) AS \(paymentMethodIdAsName)" +
            " FROM \(PaymentMethodsTable.Name)) AS PM" +
            " ON RCPTS.\(ReceiptsTable.Column.PaymentMethodId) = PM.\(paymentMethodIdAsName)" +
            " LEFT JOIN (SELECT \(CategoriesTable.Column.Name) AS \(categoryNameAsName)," +
            " \(CategoriesTable.Column.Code) AS \(categoryCodeAsName)," +
            " \(CategoriesTable.Column.Id) AS \(categoryIdAsName)," +
            " \(CategoriesTable.Column.CustomOrderId) AS \(categoryCustomOrderIdAsName) FROM \(CategoriesTable.Name)) AS CATS" +
            " ON RCPTS.\(ReceiptsTable.Column.CategoryId) = CATS.\(categoryIdAsName)" +
            whereTrip + " ORDER BY \(CategoriesTable.Column.CustomOrderId) \(ascending)"
        
        return DatabaseQueryBuilder.rawQuery(query)
    }
}
