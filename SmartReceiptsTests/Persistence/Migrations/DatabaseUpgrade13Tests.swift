//
//  DatabaseUpgrade14Tests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 31/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import XCTest
import FMDB
@testable import SmartReceipts

class DatabaseUpgrade13Tests: BaseDatabaseUpgradeTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func migrations() -> [DatabaseMigration] {
        return [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
            DatabaseUpgradeToVersion13(),
        ]
    }
    
    func testDatabaseStructureIdenticalToAndroid() {
        let androidDatabaseV13 = unmigratedTemplateDatabaseWithName("android-receipts-v13")
        checkDatabasesHaveSameStructure(reference: androidDatabaseV13, checked: testDatabase)
    }
}
