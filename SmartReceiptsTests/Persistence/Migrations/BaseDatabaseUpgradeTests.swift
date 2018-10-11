//
//  BaseDatabaseUpgradeTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 11/10/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import XCTest
import FMDB
@testable import SmartReceipts

class BaseDatabaseUpgradeTests: XCTestCase {
    
    var testDatabase: Database!
    
    override func setUp() {
        super.setUp()
    
        testDatabase = createInMemoryDatabase(false)
        testDatabase.setNotificationsDisabled(true)

        DatabaseMigration.run(migrations(), on: testDatabase)
    }
    
    func migrations() -> [DatabaseMigration] {
        XCTAssert(false, "ABSTRACT")
        return []
    }
    
    private func createInMemoryDatabase(_ migrated: Bool = true, tripsFolder: String = NSTemporaryDirectory()) -> Database {
        let database = Database(databasePath: ":memory:", tripsFolderPath: tripsFolder)
        database?.open(migrated)
        return database!
    }
    
    func unmigratedTemplateDatabaseWithName(_ name: String) -> Database {
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "db")!
        let database = Database(databasePath: path, tripsFolderPath: NSTemporaryDirectory())
        database?.open(false)
        return database!
    }
    
    // MARK: checks methods:
    
    func checkDatabasesHaveSameStructure(reference: Database, checked: Database) {
        XCTAssertEqual(reference.databaseVersion(), checked.databaseVersion())
        
        let tablesInReference = fetchAllTables(reference)
        let tablesInChecked = fetchAllTables(checked)
        
        XCTAssertEqual(tablesInReference, tablesInChecked, "Table \(tablesInReference) is equal to \(tablesInChecked)")
        
        for table in tablesInReference {
            let columnsInReference = columnsInTable(table, database: reference.databaseQueue)
            let columinsInChecked = columnsInTable(table, database: checked.databaseQueue)
            XCTAssertEqual(columnsInReference, columinsInChecked, "\(table) - \n\(columnsInReference)\n\(columinsInChecked)")
        }
    }
    
    // On iOS side database migrations are created on top of each other. On Android side there are two ways to get to current version - by migration
    // or by creating database from scratsh. This will produces slightly different tables. This dictionary will define columns that are irrelevant for
    // latest DB version and should be excluded from checks.
    fileprivate let ignoredTableColumns = [ "receipts": ["paymentmethod"], "trips": ["price", "miles_new"] ]
    
    fileprivate func columnsInTable(_ table: String, database: FMDatabaseQueue) -> [String] {
        
        var columns = [String]()
        
        database.inDatabase() {
            db in
            
            let ignoreColumns = self.ignoredTableColumns[table] ?? []
            
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
    
    /// Fetch all table names from DB
    ///
    /// - Parameter database: Database for SELECT
    /// - Returns: Array of srings 'table name'
    func fetchAllTables(_ database: Database) -> [String] {
        let rawQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
        var tableNames = [String]()
        
        database.databaseQueue.inDatabase { (db) in
            let resultSet = try! db.executeQuery(rawQuery, values: [])
            while resultSet.next() {
                if let tableName = resultSet.string(forColumnIndex: 0) {
                    tableNames.append(tableName)
                }
            }
        }
        
        return tableNames.sorted()
    }
}
