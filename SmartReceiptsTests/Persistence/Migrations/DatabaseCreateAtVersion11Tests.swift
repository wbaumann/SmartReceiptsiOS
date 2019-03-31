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

class DatabaseCreateAtVersion11Test: BaseDatabaseUpgradeTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func migrations() -> [DatabaseMigration] {
        return [DatabaseCreateAtVersion11()]
    }
    
    func testSameStructureDatabaseWasGenerated() {
        let generated = unmigratedTemplateDatabaseWithName("receipts_at_v11")
        checkDatabasesHaveSameStructure(reference: generated, checked: testDatabase)
    }
    
    func testCompareWithAndroidVersionAt11() {
        let generated = unmigratedTemplateDatabaseWithName("android-receipts-v11")
        checkDatabasesHaveSameStructure(reference: generated, checked: testDatabase)
    }
    
    func testDefaultValuesAddedForCategories() {
        XCTAssertEqual(24, testDatabase.countRows(inTable: CategoriesTable.Name), "Default categories not entered")
    }
    
    func testDefaultValuesAddedForCSVColumns() {
        XCTAssertEqual(8, testDatabase.countRows(inTable: CSVColumnTable.Name), "Default CSV columns not entered")
    }
    
    func testDefaultValuesAddedForPDFColumns() {
        XCTAssertEqual(6, testDatabase.countRows(inTable: PDFColumnTable.Name), "Default PDF columns not entered")
    }
}
