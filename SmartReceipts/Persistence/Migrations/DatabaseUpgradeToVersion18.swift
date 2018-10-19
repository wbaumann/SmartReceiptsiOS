//
//  DatabaseUpgradeToVersion18.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/10/2018.u  iuuu fu
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let COLUMN_ID = "id"
fileprivate let COLUMN_TYPE = "column_type"
fileprivate let DEPRECATED_COLUMN_TYPE_AS_NAME = "type"

class DatabaseUpgradeToVersion18: DatabaseMigration {
    
    override func version() -> UInt {
        return 18
    }
    
    override func migrate(_ database: Database) -> Bool {
        let pdfColumns = fetchColumns(table: PDFColumnTable.Name, database: database)
        let csvColumns = fetchColumns(table: CSVColumnTable.Name, database: database)
        
        return updateColumnTable(table: PDFColumnTable.Name, columns: pdfColumns, database) &&
               updateColumnTable(table: CSVColumnTable.Name, columns: csvColumns, database)
    }
    
    private func updateColumnTable(table: String, columns: [ReceiptColumn], _ database: Database) -> Bool {
        var result = database.executeUpdate("ALTER TABLE \(table) ADD COLUMN \(COLUMN_TYPE) INTEGER DEFAULT 0")
        
        for column in columns {
            let columnType = ReceiptColumn(name: column.name)?.сolumnType ?? 0
            result = result && database.executeUpdate("UPDATE \(table) SET \(COLUMN_TYPE) = \(columnType) WHERE \(DEPRECATED_COLUMN_TYPE_AS_NAME) = '\(column.name!)'")
        }
        
        result = result && database.executeUpdate("ALTER TABLE \(table) RENAME TO \(table)_tmp")
        
        result = result &&  database.executeUpdate("CREATE TABLE \(table)(\(PDFColumnTable.Column.Id) INTEGER PRIMARY KEY AUTOINCREMENT, \(COLUMN_TYPE) INTEGER DEFAULT 0, \(PDFColumnTable.Column.CustomOrderId) INTEGER DEFAULT 0,\(Database.SyncColumns.drive_sync_id) TEXT,\(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0,\(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0,\(Database.SyncColumns.last_local_modification_time) DATE)")
        
        let insertColumns = [
            SyncStateColumns.Id,
            SyncStateColumns.IsSynced,
            SyncStateColumns.MarkedForDeletion,
            SyncStateColumns.LastLocalModificationTime,
            PDFColumnTable.Column.ColumnType,
            PDFColumnTable.Column.CustomOrderId,
            PDFColumnTable.Column.Id
        ].joined(separator: ", ")
        
        result = result &&  database.executeUpdate("INSERT INTO \(table)(\(insertColumns)) SELECT \(insertColumns) FROM \(table)_tmp")
        result = result &&  database.executeUpdate("DROP TABLE \(table)_tmp")
        
        return result
    }
    
    private func fetchColumns(table: String, database: Database) -> [ReceiptColumn] {
        var result = [ReceiptColumn]()
        
        let query = "SELECT * FROM \(table) ORDER BY \(CSVColumnTable.Column.CustomOrderId) ASC"
        database.inDatabase { db in
            guard let resultSet = try? db.executeQuery(query, values: nil) else { return }
            while resultSet.next() {
                let customOrderId = resultSet.int(forColumn: CSVColumnTable.Column.CustomOrderId)
                let name = resultSet.string(forColumn: DEPRECATED_COLUMN_TYPE_AS_NAME)
                guard let column = ReceiptColumn(index: Int(customOrderId), name: name) else { continue }
                result.append(column)
            }
        }
        
        return result
    }
}
