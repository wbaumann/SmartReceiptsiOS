//
//  DatabaseUpgradeToVersion19.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/10/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let COLUMN_UUID = "entity_uuid"
fileprivate let ROWID = "ROWID"

class DatabaseUpgradeToVersion19: DatabaseMigration {
    
    override func version() -> UInt {
        return 19
    }
    
    override func migrate(_ database: Database) -> Bool {
        return addUUID(table: TripsTable.Name, database: database) &&
            addUUID(table: ReceiptsTable.Name, database: database) &&
            addUUID(table: DistanceTable.Name, database: database) &&
            addUUID(table: CategoriesTable.Name, database: database) &&
            addUUID(table: PaymentMethodsTable.Name, database: database) &&
            addUUID(table: CSVColumnTable.Name, database: database) &&
            addUUID(table: PDFColumnTable.Name, database: database)
    }
    
    private func addUUID(table: String, database: Database) -> Bool {
        var result = database.executeUpdate("ALTER TABLE \(table) ADD COLUMN \(COLUMN_UUID) TEXT")
        
        var rowIds = [Int]()
        let query = "SELECT \(ROWID) FROM \(table)"
        database.inDatabase { db in
            guard let resultSet = try? db.executeQuery(query, values: nil) else { return }
            while resultSet.next() {
                let rowId = Int(resultSet.int(forColumn: "id"))
                rowIds.append(rowId)
            }
        }
        
        for rowId in rowIds {
            let uuid = UUID().uuidString
            result = result && database.executeUpdate("UPDATE \(table) SET \(COLUMN_UUID) = '\(uuid)' WHERE \(ROWID) = \(rowId)")
        }
        
        return result
    }
}
