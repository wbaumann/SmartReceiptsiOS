//
//  DatabaseImportAndroidV14Tests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class DatabaseImportAndroidV14Tests: SmartReceiptsTestsBase {
    private var imported: Database!
    private var referenceTrip: WBTrip!
    
    override func setUp() {
        super.setUp()

        referenceTrip = db.insertTestTrip([TripsTable.Column.Name: "T"])
        db.insertTestReceipt([ReceiptsTable.Column.Parent: referenceTrip])
        db.insertTestTrip([TripsTable.Column.Name: "Cake"])
        
        imported = createMigratedDatabaseFromTemplate("android-receipts-v14")
    }
    
    func testImportWithOverwrite() {
        db.importDataFromDatabase(imported, overwrite: true)
        
        let tripsAfter = db.allTrips()
        let receiptsAfter = db.allReceipts()
        
        XCTAssertEqual(2, tripsAfter.count)
        
        // Old T had 1 receipt, imported T had 2 receipts
        XCTAssertEqual(2, receiptsAfter.count)
    }
    
    func testImportWithoutOverwrite() {
        db.importDataFromDatabase(imported, overwrite: false)

        let tripsAfter = db.allTrips()
        let receiptsAfter = db.allReceipts()
    
        XCTAssertEqual(2, tripsAfter.count)
        XCTAssertEqual(1, receiptsAfter.count)
    }
    
    func testCheckExchangeRateImported() {
        db.importDataFromDatabase(imported, overwrite: true)
        
        let receiptOne = db.receiptWithName("Test")
        XCTAssertEqual(NSDecimalNumber(string: "1.0"), receiptOne.exchangeRate)
        
        let receiptTwo = db.receiptWithName("Exchange")
        XCTAssertEqual(NSDecimalNumber(string: "1.2"), receiptTwo.exchangeRate)
    }
}
