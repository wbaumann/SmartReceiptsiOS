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

class DatabaseUpgrade14Tests: BaseDatabaseUpgradeTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func migrations() -> [DatabaseMigration] {
        return [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
            DatabaseUpgradeToVersion13(),
            DatabaseUpgradeToVersion14()
        ]
    }
    
    func testDatabaseStructureIdenticalToAndroid() {
        let androidDatabaseV14 = unmigratedTemplateDatabaseWithName("android-receipts-v14")
        checkDatabasesHaveSameStructure(reference: androidDatabaseV14, checked: testDatabase)
    }
}
