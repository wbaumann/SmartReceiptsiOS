//
//  DatabaseUpgradeToVersion17.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class DatabaseUpgradeToVersion17: DatabaseMigration {
    var version: Int {
        return 17
    }
    
    func migrate(_ database: Database) -> Bool {
        AnalyticsManager.sharedManager.record(event: .startDatabaseUpgrade(version))
        
        var result = false
        if database.hasPaymentMethodCustomOrderIdColumn() {
            result = true
        } else {
            result = addCustomOrderIdPaymentMethods(database) && updatePaymentMethodsOrderId(database)
        }
        
        AnalyticsManager.sharedManager.record(event: .finishDatabaseUpgrade(version, success: result))
        
        return result
    }
    
    private func addCustomOrderIdPaymentMethods(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(PaymentMethodsTable.Name) " +
        "ADD \(PaymentMethodsTable.Column.CustomOrderId) INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updatePaymentMethodsOrderId(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(PaymentMethodsTable.Name) " +
        "SET \(PaymentMethodsTable.Column.CustomOrderId) = ROWID"
        return database.executeUpdate(updateQuery)
    }
}
