//
//  TripFullPDFGeneratorTest.swift
//  SmartReceipts
//
//  Created by Victor on 5/18/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import XCTest
@testable import SmartReceipts

class TripFullPDFGeneratorTest: SmartReceiptsTestsBase {
    
    private var generator: TripFullPDFGenerator!
    private var testTrip: WBTrip!
    private lazy var defaultColumns: [ReceiptColumn] = { return self.db.getPdfColumns() }()
    
    override func setUp() {
        super.setUp()
        testTrip = db.createTestTrip()
        
        for i in 0...5 {
            db.insertTestReceipt([ReceiptsTable.Column.Parent: testTrip, ReceiptsTable.Column.Name: "TEST Receipt \(i)"])
        }
        
        generator = TripFullPDFGenerator(trip: testTrip, database: self.db)
    }
    
    // MARK: - Tests
    
    func testReady() {
        XCTAssertTrue(defaultColumns.count == 6, "6 columns are created initially")
    }
    
    func testNilCostCenterSuccess() {
        generator.trip.costCenter = nil
        XCTAssertTrue(db.setPdfColumns(defaultColumns))
        
        XCTAssertNil(generator.trip.costCenter)
        let result = generator.generateTo(path: NSTemporaryDirectory().appending("temp.pdf"))
        XCTAssertTrue(result)
    }
    
    func testNilCommentSuccess() {
        generator.trip.comment = nil
        XCTAssertTrue(db.setPdfColumns(defaultColumns))
        
        XCTAssertNil(generator.trip.comment)
        let result = generator.generateTo(path: NSTemporaryDirectory().appending("temp.pdf"))
        XCTAssertTrue(result)
    }
    
    func testPdfPortraitSuccess() {
        WBPreferences.setPrintReceiptTableLandscape(false)
        XCTAssertTrue(db.setPdfColumns(defaultColumns))
        
        let result = generator.generateTo(path: NSTemporaryDirectory().appending("temp.pdf"))
        XCTAssertTrue(result)
    }
    
    func testPdfPortraitFailureTooManyColumns() {
        WBPreferences.setPrintReceiptTableLandscape(false)
        XCTAssertTrue(db.setPdfColumns(defaultColumns + defaultColumns))
        
        let result = generator.generateTo(path: NSTemporaryDirectory().appending("temp.pdf"))
        XCTAssertFalse(result, "should fail here")
        XCTAssertTrue(generator.pdfRender.tableHasTooManyColumns)
    }
    
    func testPdfLandscapeSuccess() {
        WBPreferences.setPrintReceiptTableLandscape(true)
        XCTAssertTrue(db.setPdfColumns(defaultColumns + defaultColumns))
        
        let result = generator.generateTo(path: NSTemporaryDirectory().appending("temp.pdf"))
        XCTAssertTrue(result)
    }
    
    func testPdfLandscapeFailureTooManyColumns() {
        WBPreferences.setPrintReceiptTableLandscape(true)
        XCTAssertTrue(db.setPdfColumns(defaultColumns + defaultColumns + defaultColumns))
        
        let result = generator.generateTo(path: NSTemporaryDirectory().appending("temp.pdf"))
        XCTAssertFalse(result, "should fail here")
        XCTAssertTrue(generator.pdfRender.tableHasTooManyColumns)
    }
    
}
