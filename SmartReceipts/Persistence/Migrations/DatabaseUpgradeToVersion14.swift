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
    
    override func migrate(_ database: Database) -> Bool {
        return addExchangeRateToReceipts(database)
    }
    
    fileprivate func addExchangeRateToReceipts(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(ReceiptsTable.Name) " +
                         "ADD \(ReceiptsTable.Column.ExchangeRate) " +
                         "DECIMAL(10, 10) DEFAULT -1.00"
        return database.executeUpdate(alterQuery)
    }
}
