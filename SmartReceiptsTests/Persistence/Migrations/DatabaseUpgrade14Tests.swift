//
//  DatabaseUpgrade14Tests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 20/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
import FMDB
@testable import SmartReceipts

class DatabaseUpgrade14Tests: XCTestCase {
    fileprivate var testDatabase: Database!
    
    override func setUp() {
        super.setUp()
        
        testDatabase = createInMemoryDatabase(false)
        testDatabase.setNotificationsDisabled(true)

        let migrations = [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
            DatabaseUpgradeToVersion13(),
            DatabaseUpgradeToVersion14()
        ]

        DatabaseMigration.run(migrations, on: testDatabase)
    }
    
    func testDatabaseStructureIdenticalToAndroidV14() {
        let reference = unmigratedTemplateDatabaseWithName("android-receipts-v14")
        checkDatabasesHaveSameStructure(reference, checked: testDatabase)
    }
    
    fileprivate func createInMemoryDatabase(_ migrated: Bool = true, tripsFolder: String = NSTemporaryDirectory()) -> Database {
        let database = Database(databasePath: ":memory:", tripsFolderPath: tripsFolder)
        database?.open(migrated)
        return database!
    }
    
    fileprivate func unmigratedTemplateDatabaseWithName(_ name: String) -> Database {
        let path = Bundle(for: DatabaseUpgrade14Tests.self).path(forResource: name, ofType: "db")!
        let database = Database(databasePath: path, tripsFolderPath: NSTemporaryDirectory())
        database?.open(false)
        return database!
    }
    
    fileprivate func checkDatabasesHaveSameStructure(_ reference: Database, checked: Database) {
        XCTAssertEqual(reference.databaseVersion(), checked.databaseVersion())
        
        let tablesInReference = tableNames(reference.databaseQueue)
        let tablesInChecked = tableNames(checked.databaseQueue)
        
        XCTAssertEqual(tablesInReference.count, tablesInChecked.count)
        XCTAssertTrue(tablesInReference.elementsEqual(tablesInChecked))
        
        for table in tablesInReference {
            let columnsInReference = columnsInTable(table, database: reference.databaseQueue)
            let columinsInChecked = columnsInTable(table, database: checked.databaseQueue)
            
            
            XCTAssertTrue(columnsInReference.elementsEqual(columinsInChecked), "\(table) - \n\(columnsInReference)\n\(columinsInChecked)")
        }
    }
    
    // On iOS side database migrations are created on top of each other. On Android side there are two ways to get to current version - by migration
    // or by creating database from scratsh. This will produces slightly different tables. This dictionary will define columns that are irrelevant for
    // latest DB version and should be excluded from checks.
    fileprivate static let IgnoreTableColumns = [
        "receipts": ["paymentmethod"],
        "trips": ["price"] // TODO: jaanus - check this one
    ]
    
    fileprivate func columnsInTable(_ table: String, database: FMDatabaseQueue) -> [String] {
        var columns = [String]()
        database.inDatabase() {
            db in
            
            let ignoreColumns = DatabaseUpgrade14Tests.IgnoreTableColumns[table] ?? []
            
            let resultSet = try! db.executeQuery("PRAGMA table_info('\(table)')", values: [])
            while (resultSet.next()) {
                let column = resultSet.string(forColumnIndex: 1)
                
                if let _ = ignoreColumns.index(where: { $0 == column }) {
                    continue
                }
                
                columns.append(column!)
            }
        }
        
        return columns.sorted()
    }
    
    fileprivate func tableNames(_ database: FMDatabaseQueue) -> [String] {
        var tables = [String]()
        database.inDatabase() {
            db in
            
            let resultSet: FMResultSet = try! db.executeQuery("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'", values: [])
            while resultSet.next() {
                tables.append(resultSet.string(forColumnIndex: 0)!)
            }
        }
        
        return tables.sorted()
    }
}
