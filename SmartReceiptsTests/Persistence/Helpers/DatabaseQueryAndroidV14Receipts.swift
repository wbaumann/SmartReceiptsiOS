//
//  DatabaseQueryAndroidV14Receipts.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class DatabaseQueryAndroidV14Receipts: SmartReceiptsTestsBase {
    fileprivate var database: DatabaseTestsHelper!
    
    override func setUp() {
        super.setUp()

        database = createMigratedDatabase(fromTemplate: "android-receipts-v14")
    }
    
    override func tearDown() {
        database.close()
        
        super.tearDown()
    }
    
    func testListAllReceipts() {
        let receipts = database.allReceipts()
        XCTAssertEqual(2, receipts.count)
    }
}
