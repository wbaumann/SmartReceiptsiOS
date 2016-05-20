//
//  DatabaseUpgrade14Tests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 20/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest

@testable import SmartReceipts

class DatabaseUpgrade14Tests: XCTestCase {
    private var testDatabase: Database!
    
    override func setUp() {
        super.setUp()
        
        testDatabase = createInMemoryDatabase(false)

        let migrations = [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
            DatabaseUpgradeToVersion13(),
            DatabaseUpgradeToVersion14()
        ]

        DatabaseMigration.runMigrations(migrations, onDatabase: testDatabase)
    }
    
    func testDatabaseStructureIdenticalToAndroidV14() {
        XCTAssertTrue(false, "TODO jaanus: check against android database v14")
    }
    
    private func createInMemoryDatabase(migrated: Bool = true, tripsFolder: String = NSTemporaryDirectory()) -> Database {
        let database = Database(databasePath: ":memory:", tripsFolederPath: tripsFolder)
        database.open(migrated)
        return database
    }
}
