//
//  DatabaseUpgradeToVersion14.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class DatabaseUpgradeToVersion14: DatabaseMigration {
    override func version() -> UInt {
        return 14
    }
    
    override func migrate(database: Database) -> Bool {
        return addDefaultValueToReceipts(database)
            && doMigrationsToGetParityWithAndroidDatabase(database)
    }
    
    private func addDefaultValueToReceipts(database: Database) -> Bool {
        let method = PaymentMethod.defaultMethod(database)
        let updateQuery = "UPDATE \(ReceiptsTable.Name) " +
                          "SET \(ReceiptsTable.Column.PaymentMethodId) = \(method.objectId) " +
                          "WHERE \(ReceiptsTable.Column.PaymentMethodId) IS NULL"
        return database.executeUpdate(updateQuery)
    }
    
    private func doMigrationsToGetParityWithAndroidDatabase(database: Database) -> Bool {
        print("Finish migrations implementation")
        return true
    }
}