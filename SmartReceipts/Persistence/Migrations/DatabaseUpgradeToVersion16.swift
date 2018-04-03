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
        return  updateCategoriesPrimaryKey(database) &&
                addCustomOrderIdToCategories(database) &&
                updateCategoriesOrderId(database) &&
            
                updateReceiptsCategoryReference(database) &&
                addCustomOrderIdToReceipts(database) &&
                updateReceiptsOrderIdWithDate(database) &&

                addCustomOrderIdToPDFColumns(database) &&
                updatePDFColumnsOrderId(database) &&

                addCustomOrderIdToCSVColumns(database) &&
updateCSVColumnsOrderId(database)
    }
    
    //MARK: - Receipts
    
    private func updateReceiptsCategoryReference(_ db: Database) -> Bool {
        var result = db.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) ADD \(ReceiptsTable.Column.CategoryId) INTEGER REFERENCES \(CategoriesTable.Name) ON DELETE NO ACTION")
        
        result = result && db.executeUpdate("UPDATE \(ReceiptsTable.Name) SET \(ReceiptsTable.Column.CategoryId) = (SELECT \(CategoriesTable.Column.Id) FROM \(CategoriesTable.Name) WHERE \(CategoriesTable.Column.Name) = \(ReceiptsTable.Column.Category) LIMIT 1)")
        
        result = result && db.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) RENAME TO \(ReceiptsTable.Name)_copy")
        
        db.createReceiptsTable()
        
        result = result && db.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) ADD \(Database.SyncColumns.drive_sync_id) TEXT")
        result = result && db.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) ADD \(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0")
        result = result && db.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) ADD \(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0")
        result = result && db.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) ADD \(Database.SyncColumns.last_local_modification_time) DATE")
        
        let fieldsToCopy = "\(Database.SyncColumns.drive_sync_id), \(Database.SyncColumns.drive_is_synced), \(Database.SyncColumns.drive_marked_for_deletion), \(Database.SyncColumns.last_local_modification_time), \(ReceiptsTable.Column.CategoryId), \(ReceiptsTable.Column.Id), \(ReceiptsTable.Column.Path), \(ReceiptsTable.Column.Parent), \(ReceiptsTable.Column.Name), \(ReceiptsTable.Column.Date), \(ReceiptsTable.Column.Timezone), \(ReceiptsTable.Column.ISO4217), \(ReceiptsTable.Column.Price), \(ReceiptsTable.Column.Tax), \(ReceiptsTable.Column.PaymentMethodId), \(ReceiptsTable.Column.Reimbursable), \(ReceiptsTable.Column.NotFullPageImage), \(ReceiptsTable.Column.ExtraEditText1), \(ReceiptsTable.Column.ExtraEditText2), \(ReceiptsTable.Column.ExtraEditText3)"
        
        result = result && db.executeUpdate("INSERT INTO \(ReceiptsTable.Name) (\(fieldsToCopy)) SELECT \(fieldsToCopy) FROM \(ReceiptsTable.Name)_copy")
        
        result = result && db.executeUpdate("DROP TABLE \(ReceiptsTable.Name)_copy")
        return result
    }
    
    private func addCustomOrderIdToReceipts(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(ReceiptsTable.Name) " +
                         "ADD \(ReceiptsTable.Column.CustomOrderId) INTEGER DEFAULT 0"
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
        
        var result = database.executeUpdate("CREATE TABLE \(CategoriesTable.Name)_backup(\(CategoriesTable.Column.Name) TEXT, \(CategoriesTable.Column.Code) TEXT, \(CategoriesTable.Column.Breakdown) BOOLEAN DEFAULT 1,\(Database.SyncColumns.drive_sync_id) TEXT,\(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0,\(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0,\(Database.SyncColumns.last_local_modification_time) DATE, \(CategoriesTable.Column.Id) INTEGER PRIMARY KEY AUTOINCREMENT)")
            
        result = result && database.executeUpdate("INSERT INTO \(CategoriesTable.Name)_backup(\(fields),id) SELECT \(fields),ROWID FROM \(CategoriesTable.Name)")
        
        result = result && database.executeUpdate("DROP TABLE \(CategoriesTable.Name)")
        
        result = result && database.executeUpdate("ALTER TABLE \(CategoriesTable.Name)_backup RENAME TO \(CategoriesTable.Name)")

        return result
    }
    
    private func addCustomOrderIdToCategories(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(CategoriesTable.Name) " +
                         "ADD \(CategoriesTable.Column.CustomOrderId) INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updateCategoriesOrderId(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(CategoriesTable.Name) " +
                          "SET \(CategoriesTable.Column.CustomOrderId) = ROWID"
        return database.executeUpdate(updateQuery)
    }
    
    //MARK: - PDF Columns
    
    private func addCustomOrderIdToPDFColumns(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(PDFColumnTable.Name) " +
            "ADD \(PDFColumnTable.Column.CustomOrderId) INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updatePDFColumnsOrderId(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(PDFColumnTable.Name) " +
            "SET \(PDFColumnTable.Column.CustomOrderId) = ROWID"
        return database.executeUpdate(updateQuery)
    }
    
    //MARK: - CSV Columns
    
    private func addCustomOrderIdToCSVColumns(_ database: Database) -> Bool {
        let alterQuery = "ALTER TABLE \(CSVColumnTable.Name) " +
            "ADD \(CSVColumnTable.Column.CustomOrderId) INTEGER DEFAULT 0"
        return database.executeUpdate(alterQuery)
    }
    
    private func updateCSVColumnsOrderId(_ database: Database) -> Bool {
        let updateQuery = "UPDATE \(CSVColumnTable.Name) " +
            "SET \(CSVColumnTable.Column.CustomOrderId) = ROWID"
        return database.executeUpdate(updateQuery)
    }
}
