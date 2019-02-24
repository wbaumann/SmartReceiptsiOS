//
//  DatabaseReceiptsDatesTest.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 03/10/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class DatabaseReceiptsDatesTest: SmartReceiptsTestsBase {
    
    // Defines the accuracy buffer for these tests to avoid failures related to slower build times
    let accuracyBuffer = TimeInterval(10)
    
    var testTrip: WBTrip!

    override func setUp() {
        super.setUp()
        testTrip = db.createTestTrip()
        db.insertTestReceipt([ReceiptsTable.Column.ParentId : self.testTrip, ReceiptsTable.Column.Date : NSDate().addingDays(-1)])
        db.insertTestReceipt([ReceiptsTable.Column.ParentId : self.testTrip, ReceiptsTable.Column.Date : NSDate().addingDays(-1)])
        
        db.insertTestReceipt([ReceiptsTable.Column.ParentId : self.testTrip, ReceiptsTable.Column.Date : NSDate()])
        db.insertTestReceipt([ReceiptsTable.Column.ParentId : self.testTrip, ReceiptsTable.Column.Date : NSDate()])
        db.insertTestReceipt([ReceiptsTable.Column.ParentId : self.testTrip, ReceiptsTable.Column.Date : NSDate()])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMaxSecondsYesterday() {
        let date = NSDate()
        let maxSeconds = db.maxSecondForReceipts(in: testTrip, on: date.addingDays(-1))
        XCTAssertEqual(date.secondsOfDay(), maxSeconds, accuracy: accuracyBuffer)
    }
    
    func testMaxSecondsToday() {
        let date = NSDate()
        let maxSeconds = db.maxSecondForReceipts(in: testTrip, on: date as Date)
        XCTAssertEqual(date.secondsOfDay(), maxSeconds, accuracy: accuracyBuffer)
    }

}
