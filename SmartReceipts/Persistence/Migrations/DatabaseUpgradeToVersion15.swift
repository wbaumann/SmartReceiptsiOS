//
//  DatabaseUpgradeToVersion15.swift
//  SmartReceipts
//
//  Created by Victor on 4/3/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

/// In DB v15 we have added support for automatic backups
///
/// Important: Deletes are no longer directly done; instead, we process a delete a mark an item as deleted (so it's no longer fetched). Only once the sync is successful do we fully delete it
class DatabaseUpgradeToVersion15: DatabaseMigration {
    
    override func version() -> UInt {
        return 15
    }
    
    override func migrate(_ database: Database) -> Bool {
        let migrationSuccess = addSyncInformation(database)
        return migrationSuccess
    }
    
    // MARK: - Private:
    
    /// Add information about sync tracking
    private func addSyncInformation(_ database: Database) -> Bool {
        var success = false
        let tableNames = fetchAllTables(database)
        
        for aTable in tableNames {
            
            if aTable == "android_metadata" {
                continue
            }
            
            let alter1 = "ALTER TABLE \(aTable) ADD \(Database.SyncColumns.drive_sync_id) TEXT"
            let alter2 = "ALTER TABLE \(aTable) ADD \(Database.SyncColumns.drive_is_synced) BOOLEAN DEFAULT 0"
            let alter3 = "ALTER TABLE \(aTable) ADD \(Database.SyncColumns.drive_marked_for_deletion) BOOLEAN DEFAULT 0"
            let alter4 = "ALTER TABLE \(aTable) ADD \(Database.SyncColumns.last_local_modification_time) DATE"
            
            if database.executeUpdate(alter1) && database.executeUpdate(alter2) && database.executeUpdate(alter3) && database.executeUpdate(alter4) {
                success = true
            } else {
                Logger.error("addSyncInformation failed for table \(aTable)")
                return false
            }
        }
        
        return success
    }
    
    
    /// Fetch all table names from DB
    ///
    /// - Parameter database: Database for SELECT
    /// - Returns: Array of srings 'table name'
    private func fetchAllTables(_ database: Database) -> [String] {
        let rawQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
        var tableNames = [String]()
        
        database.databaseQueue.inDatabase { (db) in
            do {
                let resultSet = try db.executeQuery(rawQuery, values: [])
                while resultSet.next() {
                    if let tableName = resultSet.string(forColumnIndex: 0) {
                        tableNames.append(tableName)
                    }
                }
            } catch {
                Logger.error("fetchAllTables error")
            }
        }
        
        
        
        Logger.debug("fetchAllTables tableNames: \(tableNames)")
        return tableNames
    }
    
}
