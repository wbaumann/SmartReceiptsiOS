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

class DatabaseUpgrade12Tests: BaseDatabaseUpgradeTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func migrations() -> [DatabaseMigration] {
        return [
            DatabaseCreateAtVersion11(),
            DatabaseUpgradeToVersion12(),
        ]
    }
    
    func testDefaultPaymentMethodsAddedByMigration() {
        XCTAssertEqual(5, db.countRows(inTable: PaymentMethodsTable.Name))
    }
}
