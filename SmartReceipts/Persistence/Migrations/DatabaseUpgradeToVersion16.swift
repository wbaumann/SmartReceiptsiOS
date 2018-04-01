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
               updateCategoriesPrimaryKey(database) &&
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
    
    private func updateCategoriesPrimaryKey(_ database: Database) -> Bool {
        let fields = "\(CategoriesTable.Column.Code),\(CategoriesTable.Column.Name),\(CategoriesTable.Column.Breakdown), \(Database.SyncColumns.drive_sync_id),\(Database.SyncColumns.drive_is_synced),\(Database.SyncColumns.drive_marked_for_deletion),\(Database.SyncColumns.last_local_modification_time)"
        
        let db = Database.sharedInstance()!
        
        var result = db.executeUpdate("CREATE TABLE \(CategoriesTable.Name)_backup(\(CategoriesTable.Column.Name) TEXT, \(CategoriesTable.Column.Code) TEXT, \(CategoriesTable.Column.Breakdown) BOOLEAN DEFAULT 1,\(Database.SyncColumns.drive_sync_id) TEXT,\(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0,\(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0,\(Database.SyncColumns.last_local_modification_time) DATE, \(CategoriesTable.Column.Id) INTEGER PRIMARY KEY AUTOINCREMENT)")
            
        result = result && db.executeUpdate("INSERT INTO \(CategoriesTable.Name)_backup(\(fields),id) SELECT \(fields),ROWID FROM \(CategoriesTable.Name)")
        
        result = result && db.executeUpdate("DROP TABLE \(CategoriesTable.Name)")
        
        result = result && db.executeUpdate("ALTER TABLE \(CategoriesTable.Name)_backup RENAME TO \(CategoriesTable.Name)")

        return result
    }
    
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
