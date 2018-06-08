//
//  DatabaseUpgradeToVersion17.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
class DatabaseUpgradeToVersion17: DatabaseMigration {
    override func version() -> UInt {
        return 17
    }
    
    override func migrate(_ database: Database) -> Bool {
        if database.hasPaymentMethodCustomOrderIdColumn() {
            return true
        } else {
            return addCustomOrderIdPaymentMethods(database) && updatePaymentMethodsOrderId(database)
        }
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
