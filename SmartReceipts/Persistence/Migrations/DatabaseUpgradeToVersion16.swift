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
               updateReceiptsOrderIdWithDate(database) &&
               addCustomOrderIdToCategories(database) &&
               updateCategoriesOrderIdWithDate(database)
    }
    
    //MARK: - Receipts
    
    private func addCustomOrderIdToReceipts(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(ReceiptsTable.Name) " +
                         "ADD \(ReceiptsTable.Column.CustomOrderId) " +
                         "INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updateReceiptsOrderIdWithDate(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(ReceiptsTable.Name) " +
                          "SET \(ReceiptsTable.Column.CustomOrderId) = \(ReceiptsTable.Column.Date)"
        return database.executeUpdate(updateQuery)
    }
    
    //MARK: - Categories
    
    private func addCustomOrderIdToCategories(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(CategoriesTable.Name) " +
                         "ADD \(CategoriesTable.Column.CustomOrderId) " +
                         "INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updateCategoriesOrderIdWithDate(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(CategoriesTable.Name) " +
                          "SET \(CategoriesTable.Column.CustomOrderId) = ROWID"
        return database.executeUpdate(updateQuery)
    }
}
