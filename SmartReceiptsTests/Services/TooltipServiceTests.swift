//
//  TooltipServiceTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import RxTest
import RxSwift

class TooltipServiceTests: SmartReceiptsTestsBase {
    
    var tooltipService: TooltipService!
    
    override func setUp() {
        super.setUp()
        tooltipService = TooltipService.service(for: db)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testServiceWorkflow() {
        resetUserDefaults()
        
        XCTAssertFalse(tooltipService.moveToGenerateTrigger())
        
        let trip = db.createTestTrip()
        db.save(trip)
        XCTAssertFalse(tooltipService.moveToGenerateTrigger())
        
        addReceipt(NSDecimalNumber(decimal: 10.5), trip: trip)
        XCTAssertTrue(tooltipService.moveToGenerateTrigger())
        addReceipt(NSDecimalNumber(decimal: 2.5), trip: trip)
        XCTAssertTrue(tooltipService.moveToGenerateTrigger())
        
        let trip2 = db.createTestTrip()
        db.save(trip2)
        XCTAssertFalse(tooltipService.moveToGenerateTrigger())
        db.delete(trip2)
        XCTAssertTrue(tooltipService.moveToGenerateTrigger())
        XCTAssertNotNil(tooltipService.tooltipText(for: .receipts))
        
        tooltipService.markMoveToGenerateDismiss()
        XCTAssertFalse(tooltipService.moveToGenerateTrigger())
        XCTAssertNil(tooltipService.tooltipText(for: .receipts))
    }
    
    func testMarkGeneratedReport() {
        resetUserDefaults()
        
        let trip = db.createTestTrip()
        db.save(trip)
        addReceipt(NSDecimalNumber(decimal: 10.5), trip: trip)
        XCTAssertTrue(tooltipService.moveToGenerateTrigger())
        tooltipService.markReportGenerated()
        XCTAssertFalse(tooltipService.moveToGenerateTrigger())
    }
    
    private func addReceipt(_ amount: NSDecimalNumber, currency: String = "USD", exchangeRate: NSDecimalNumber = .zero, trip: WBTrip) {
        db.insertTestReceipt([ReceiptsTable.Column.Parent: trip, ReceiptsTable.Column.Price: amount, ReceiptsTable.Column.ISO4217: currency, ReceiptsTable.Column.ExchangeRate: exchangeRate])
    }
    
    private func resetUserDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
}
