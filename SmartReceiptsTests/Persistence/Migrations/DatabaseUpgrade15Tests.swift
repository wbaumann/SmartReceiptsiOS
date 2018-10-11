//
//  DatabaseUpgrade15Tests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/10/2018.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import XCTest
import FMDB
@testable import SmartReceipts

class DatabaseUpgrade15Tests: BaseDatabaseUpgradeTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func migrations() -> [DatabaseMigration] {
        return [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
            DatabaseUpgradeToVersion13(),
            DatabaseUpgradeToVersion14(),
            DatabaseUpgradeToVersion15()
        ]
    }
    
    func testDatabaseStructureIdenticalToAndroid() {
        let androidDatabaseV15 = unmigratedTemplateDatabaseWithName("android-receipts-v15")
        checkDatabasesHaveSameStructure(reference: androidDatabaseV15, checked: testDatabase)
    }
}
