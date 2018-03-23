//
//  DatabaseUpgradeToVersion16.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/03/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class DatabaseUpgradeToVersion16: DatabaseMigration {
    override func version() -> UInt {
        return 16
    }
    
    override func migrate(_ database: Database) -> Bool {
        
        return addCustomOrderIdToReceipts(database) &&
               updateOrderIdWithDate(database)
    }
    
    private func addCustomOrderIdToReceipts(_ database: Database) -> Bool {
        
        let alterQuery = "ALTER TABLE \(ReceiptsTable.Name) " +
                         "ADD \(ReceiptsTable.Column.CustomOrderId) " +
                         "INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updateOrderIdWithDate(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(ReceiptsTable.Name) " +
                          "SET \(ReceiptsTable.Column.CustomOrderId) = \(ReceiptsTable.Column.Date)"
        return database.executeUpdate(updateQuery)
    }
}
