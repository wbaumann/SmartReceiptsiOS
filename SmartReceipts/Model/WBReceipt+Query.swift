//
//  WBReceipt+Query.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension WBReceipt {
    
    
    class func selectAllQueryForTrip(trip: WBTrip?) -> DatabaseQueryBuilder {
        return self.selectAllQueryForTrip(trip, isAscending: false)
    }
    
    class func selectAllQueryForTrip(trip: WBTrip?, isAscending: Bool) -> DatabaseQueryBuilder {
        
        let receiptIdFullName = "\(ReceiptsTable.Name).\(ReceiptsTable.Column.Id)"
        let receiptIdAsName = "\(ReceiptsTable.Name)_\(ReceiptsTable.Column.Id)"
        let paymentMethodIdFullName = "\(PaymentMethodsTable.Name).\(PaymentMethodsTable.Column.Id)"
        let paymentMethodIdAsName = "\(PaymentMethodsTable.Name)_\(PaymentMethodsTable.Column.Id)"
        
        let selectAll = DatabaseQueryBuilder.selectAllStatementForTable(ReceiptsTable.Name)
        if let trip = trip {
            selectAll.`where`(ReceiptsTable.Column.Parent, value: trip.name)
        }
        selectAll.select(receiptIdFullName, as: receiptIdAsName)
        selectAll.select(paymentMethodIdFullName, as: paymentMethodIdAsName)
        selectAll.leftJoin(PaymentMethodsTable.Name, on: ReceiptsTable.Column.PaymentMethodId, equalTo: PaymentMethodsTable.Column.Id)
    
        selectAll.orderBy(ReceiptsTable.Column.Date, ascending: isAscending)
        
        return selectAll
    }
}