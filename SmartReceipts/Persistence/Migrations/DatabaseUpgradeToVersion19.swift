//
//  DatabaseUpgradeToVersion19.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/10/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let ROWID = "ROWID"
fileprivate let DEPRECATED_PARENT = "parent"

fileprivate typealias TripIdNamePair = (id: Int, name: String)

class DatabaseUpgradeToVersion19: DatabaseMigration {
    
    var version: Int {
        return 19
    }
    
    func migrate(_ database: Database) -> Bool {
        AnalyticsManager.sharedManager.record(event: .startDatabaseUpgrade(version))
        AnalyticsManager.sharedManager.record(event: .distancePersistNewDistance())
        
        let result = updateTripsPrimaryKey(database: database) &&
            
            updateDistanceParent(database: database) &&
            updateReceiptsParent(database: database) &&
            
            addUUID(table: TripsTable.Name, database: database) &&
            addUUID(table: ReceiptsTable.Name, database: database) &&
            addUUID(table: DistanceTable.Name, database: database) &&
            addUUID(table: CategoriesTable.Name, database: database) &&
            addUUID(table: PaymentMethodsTable.Name, database: database) &&
            addUUID(table: CSVColumnTable.Name, database: database) &&
            addUUID(table: PDFColumnTable.Name, database: database)
        
        AnalyticsManager.sharedManager.record(event: .finishDatabaseUpgrade(version, success: result))
        
        return result
    }
    
    private func addUUID(table: String, database: Database) -> Bool {
        var result = database.executeUpdate("ALTER TABLE \(table) ADD COLUMN \(CommonColumns.EntityUUID) TEXT")
        
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
            result = result && database.executeUpdate("UPDATE \(table) SET \(CommonColumns.EntityUUID) = '\(uuid)' WHERE \(ROWID) = \(rowId)")
        }
        
        return result
    }
    
    private func updateTripsPrimaryKey(database: Database) -> Bool {
        var result = database.executeUpdate("ALTER TABLE \(TripsTable.Name) RENAME TO \(TripsTable.Name)_tmp")
        
        result = result &&  database.executeUpdate("CREATE TABLE \(TripsTable.Name)(\(TripsTable.Column.Id) INTEGER PRIMARY KEY AUTOINCREMENT, \(TripsTable.Column.Name) TEXT UNIQUE, \(TripsTable.Column.From) DATE, \(TripsTable.Column.To) DATE, \(TripsTable.Column.FromTimezone) TEXT, \(TripsTable.Column.ToTimezone) TEXT, \(TripsTable.Column.Comment) TEXT, \(TripsTable.Column.CostCenter) TEXT, \(TripsTable.Column.DefaultCurrency) TEXT, \(TripsTable.Column.ProcessingStatus) TEXT, \(TripsTable.Column.Filters) TEXT, \(Database.SyncColumns.drive_sync_id) TEXT,\(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0,\(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0,\(Database.SyncColumns.last_local_modification_time) DATE)")
        
        let insertColumns = [
            TripsTable.Column.Name,
            TripsTable.Column.From,
            TripsTable.Column.To,
            TripsTable.Column.FromTimezone,
            TripsTable.Column.ToTimezone,
            TripsTable.Column.Comment,
            TripsTable.Column.CostCenter,
            TripsTable.Column.DefaultCurrency,
            TripsTable.Column.ProcessingStatus,
            TripsTable.Column.Filters,
            SyncStateColumns.Id,
            SyncStateColumns.IsSynced,
            SyncStateColumns.MarkedForDeletion,
            SyncStateColumns.LastLocalModificationTime,
        ].joined(separator: ", ")
        
        result = result &&  database.executeUpdate("INSERT INTO \(TripsTable.Name)(\(insertColumns)) SELECT \(insertColumns) FROM \(TripsTable.Name)_tmp")
        result = result &&  database.executeUpdate("DROP TABLE \(TripsTable.Name)_tmp")
        
        return result
    }
    
    private func updateDistanceParent(database: Database) -> Bool {
        var result = database.executeUpdate("ALTER TABLE \(DistanceTable.Name) ADD COLUMN \(DistanceTable.Column.ParentId) INTEGER REFERENCES \(TripsTable.Column.Name) ON DELETE CASCADE")
        
        result = result && database.executeUpdate("UPDATE \(DistanceTable.Name) SET \(DistanceTable.Column.ParentId) = (SELECT \(TripsTable.Column.Id) FROM \(TripsTable.Name) WHERE \(TripsTable.Column.Name) = \(DEPRECATED_PARENT) LIMIT 1)")
        
        result = result && database.executeUpdate("ALTER TABLE \(DistanceTable.Name) RENAME TO \(DistanceTable.Name)_tmp")
        
        result = result &&  database.executeUpdate("CREATE TABLE \(DistanceTable.Name) (\(DistanceTable.Column.Id) INTEGER PRIMARY KEY AUTOINCREMENT, \(DistanceTable.Column.ParentId) INTEGER REFERENCES \(TripsTable.Column.Name) ON DELETE CASCADE, \(DistanceTable.Column.Distance) DECIMAL(10, 2) DEFAULT 0.00, \(DistanceTable.Column.Location) TEXT, \(DistanceTable.Column.Date) DATE, \(DistanceTable.Column.Timezone) TEXT, \(DistanceTable.Column.Comment) TEXT, \(DistanceTable.Column.RateCurrency) TEXT NOT NULL, \(DistanceTable.Column.Rate) DECIMAL(10, 2) DEFAULT 0.00, \(Database.SyncColumns.drive_sync_id) TEXT,\(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0,\(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0,\(Database.SyncColumns.last_local_modification_time) DATE)")
        
        
        let insertColumns = [
            DistanceTable.Column.Id,
            DistanceTable.Column.ParentId,
            DistanceTable.Column.Distance,
            DistanceTable.Column.Location,
            DistanceTable.Column.Date,
            DistanceTable.Column.Timezone,
            DistanceTable.Column.Comment,
            DistanceTable.Column.Rate,
            DistanceTable.Column.RateCurrency,
            SyncStateColumns.Id,
            SyncStateColumns.IsSynced,
            SyncStateColumns.MarkedForDeletion,
            SyncStateColumns.LastLocalModificationTime,
        ].joined(separator: ", ")
        
        result = result &&  database.executeUpdate("INSERT INTO \(DistanceTable.Name)(\(insertColumns)) SELECT \(insertColumns) FROM \(DistanceTable.Name)_tmp")
        result = result &&  database.executeUpdate("DROP TABLE \(DistanceTable.Name)_tmp")
        
        return result
    }
    
    private func updateReceiptsParent(database: Database) -> Bool {
        var result = database.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) ADD COLUMN \(ReceiptsTable.Column.ParentId) INTEGER REFERENCES \(TripsTable.Column.Name) ON DELETE CASCADE")
        
        result = result && database.executeUpdate("UPDATE \(ReceiptsTable.Name) SET \(ReceiptsTable.Column.ParentId) = (SELECT \(TripsTable.Column.Id) FROM \(TripsTable.Name) WHERE \(TripsTable.Column.Name) = \(DEPRECATED_PARENT) LIMIT 1)")
        
        result = result && database.executeUpdate("ALTER TABLE \(ReceiptsTable.Name) RENAME TO \(ReceiptsTable.Name)_tmp")
        
        result = result &&  database.executeUpdate(["CREATE TABLE ", ReceiptsTable.Name, "(",
                           ReceiptsTable.Column.Id, " INTEGER PRIMARY KEY AUTOINCREMENT, ",
                           ReceiptsTable.Column.Path, " TEXT, ",
                           ReceiptsTable.Column.ParentId, " TEXT REFERENCES ", TripsTable.Name, " ON DELETE CASCADE, ",
                           ReceiptsTable.Column.Name, " TEXT DEFAULT \"New Receipt\", ",
                           ReceiptsTable.Column.CategoryId, " INTEGER REFERENCES ", CategoriesTable.Name, " ON DELETE NO ACTION, ",
                           ReceiptsTable.Column.Date, " DATE DEFAULT (DATE('now', 'localtime')), ",
                           ReceiptsTable.Column.Timezone, " TEXT, ",
                           ReceiptsTable.Column.Comment, " TEXT, ",
                           ReceiptsTable.Column.ISO4217, " TEXT NOT NULL, ",
                           ReceiptsTable.Column.Price, " DECIMAL(10, 2) DEFAULT 0.00, ",
                           ReceiptsTable.Column.Tax, " DECIMAL(10, 2) DEFAULT 0.00, ",
                           ReceiptsTable.Column.ExchangeRate, " DECIMAL(10, 10) DEFAULT 0.00, ",
                           ReceiptsTable.Column.PaymentMethodId, " INTEGER REFERENCES ", PaymentMethodsTable.Name, " ON DELETE NO ACTION, ",
                           ReceiptsTable.Column.Reimbursable, " BOOLEAN DEFAULT 1, ",
                           ReceiptsTable.Column.NotFullPageImage, " BOOLEAN DEFAULT 1, ",
                           ReceiptsTable.Column.ExtraEditText1, " TEXT, ",
                           ReceiptsTable.Column.ExtraEditText2, " TEXT, ",
                           ReceiptsTable.Column.ExtraEditText3, " TEXT, ",
                           ReceiptsTable.Column.ProcessingStatus, " TEXT, ",
                           ReceiptsTable.Column.CustomOrderId, " INTEGER DEFAULT 0, ",
                           Database.SyncColumns.drive_sync_id, " TEXT, ",
                           Database.SyncColumns.drive_is_synced, " BOOLEAN DEFAULT 0, ",
                           Database.SyncColumns.drive_marked_for_deletion, " BOOLEAN DEFAULT 0, ",
                           Database.SyncColumns.last_local_modification_time, " DATE", ")"].joined())
        
        let insertColumns = [
            ReceiptsTable.Column.Id,
            ReceiptsTable.Column.Path,
            ReceiptsTable.Column.Name,
            ReceiptsTable.Column.ParentId,
            ReceiptsTable.Column.CategoryId,
            ReceiptsTable.Column.Price,
            ReceiptsTable.Column.Tax,
            ReceiptsTable.Column.ExchangeRate,
            ReceiptsTable.Column.Date,
            ReceiptsTable.Column.Timezone,
            ReceiptsTable.Column.Comment,
            ReceiptsTable.Column.Reimbursable,
            ReceiptsTable.Column.ISO4217,
            ReceiptsTable.Column.PaymentMethodId,
            ReceiptsTable.Column.NotFullPageImage,
            ReceiptsTable.Column.ProcessingStatus,
            ReceiptsTable.Column.ExtraEditText1,
            ReceiptsTable.Column.ExtraEditText2,
            ReceiptsTable.Column.ExtraEditText3,
            ReceiptsTable.Column.CustomOrderId,
            SyncStateColumns.Id,
            SyncStateColumns.IsSynced,
            SyncStateColumns.MarkedForDeletion,
            SyncStateColumns.LastLocalModificationTime,
        ].joined(separator: ", ")
        
        result = result &&  database.executeUpdate("INSERT INTO \(ReceiptsTable.Name)(\(insertColumns)) SELECT \(insertColumns) FROM \(ReceiptsTable.Name)_tmp")
        result = result &&  database.executeUpdate("DROP TABLE \(ReceiptsTable.Name)_tmp")
        
        return result
    }
}
