//
//  DatabaseUpgrade19Tests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 09/10/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import XCTest
import FMDB
@testable import SmartReceipts

class DatabaseUpgrade19Tests: BaseDatabaseUpgradeTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func migrations() -> [DatabaseMigration] {
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
    }
    
    func testDatabaseStructureIdenticalToAndroid() {
        let androidDatabaseV19 = unmigratedTemplateDatabaseWithName("android-receipts-v19")
        checkDatabasesHaveSameStructure(reference: androidDatabaseV19, checked: testDatabase)
    }
}
