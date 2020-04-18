//
//  DatabaseMigration.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

let DB_VERSION_UUID = 19

protocol DatabaseMigration {
    var version: Int { get }
    func migrate(_ database: Database) -> Bool
}

class DatabaseMigrator: NSObject {
    lazy var feedbackComposer: FeedbackComposer = FeedbackComposer()
    
    private static var allMigrations: [DatabaseMigration] = {
        return [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
            DatabaseUpgradeToVersion13(),
            DatabaseUpgradeToVersion14(),
            DatabaseUpgradeToVersion15(),
            DatabaseUpgradeToVersion16(),
            DatabaseUpgradeToVersion17(),
            DatabaseUpgradeToVersion18(),
            DatabaseUpgradeToVersion19()
        ]
    }()
    
    @objc func migrate(database: Database) -> Bool {
        let dbPath = database.pathToDatabase
        let copyName = "migration_failed.db"
        let copyPath = dbPath.asNSString.deletingLastPathComponent.asNSString.appendingPathComponent(copyName)
        _ = FileManager.forceCopy(from: dbPath, to: copyPath)
        let migrationResult = run(migrations: DatabaseMigrator.allMigrations, database: database)
        
        if !migrationResult {
            database.close()
            try? FileManager().removeItem(atPath: dbPath)
            _ = FileManager.forceCopy(from: copyPath, to: dbPath)
            
            processFailedMigration(databasePath: copyPath)
        } else {
            processSuccessMigration()
        }
        
        try? FileManager().removeItem(atPath: copyPath)
        return migrationResult
    }
    
    func run(migrations: [DatabaseMigration], database: Database) -> Bool {
        let tick = TickTock.tick()
        
        var currentVersion = database.databaseVersion()
        Logger.debug("Current version: \(currentVersion)")
        
        for migration in migrations {
            if currentVersion >= migration.version {
                Logger.error("DB at version \(currentVersion), will skip migration to \(migration.version)")
                continue
            }
            
            Logger.info("Migrate to version \(migration.version)")
            if !migration.migrate(database) {
                Logger.error("Failed on migration \(migration.version)")
                return false
            }
            
            currentVersion = migration.version
            database.setDatabaseVersion(currentVersion)
        }
        
        Logger.debug("Migration time \(tick.tock())")
        
        return true
    }
    
}

extension DatabaseMigrator {
    @objc static var UUIDVersion: Int = 19
}
