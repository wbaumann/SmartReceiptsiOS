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
        
        let trip = db.createTestTrip()
        db.save(trip)
        
        func checkTrigger() -> Bool {
            return tooltipService.moveToGenerateTrigger(for: trip)
        }
        
        XCTAssertFalse(checkTrigger())
        
        addReceipt(NSDecimalNumber(decimal: 10.5), trip: trip)
        XCTAssertTrue(checkTrigger())
        addReceipt(NSDecimalNumber(decimal: 2.5), trip: trip)
        XCTAssertTrue(checkTrigger())
        
        let trip2 = db.createTestTrip()
        db.save(trip2)
        XCTAssertFalse(tooltipService.moveToGenerateTrigger(for: trip2))
        addReceipt(NSDecimalNumber(decimal: 2.5), trip: trip2)
        XCTAssertTrue(tooltipService.moveToGenerateTrigger(for: trip2))
        
        XCTAssertTrue(checkTrigger())
        XCTAssertNotNil(tooltipService.generateTooltip(for: trip))
        
        tooltipService.markMoveToGenerateDismiss()
        XCTAssertFalse(checkTrigger())
        XCTAssertNil(tooltipService.generateTooltip(for: trip))
    }
    
    func testMarkGeneratedReport() {
        resetUserDefaults()
        
        let trip = db.createTestTrip()
        db.save(trip)
        
        addReceipt(NSDecimalNumber(decimal: 10.5), trip: trip)
        XCTAssertTrue(tooltipService.moveToGenerateTrigger(for: trip))
        tooltipService.markReportGenerated()
        XCTAssertFalse(tooltipService.moveToGenerateTrigger(for: trip))
    }
    
    private func addReceipt(_ amount: NSDecimalNumber, currency: String = "USD", exchangeRate: NSDecimalNumber = .zero, trip: WBTrip) {
        db.insertTestReceipt([ReceiptsTable.Column.ParentId: trip, ReceiptsTable.Column.Price: amount, ReceiptsTable.Column.ISO4217: currency, ReceiptsTable.Column.ExchangeRate: exchangeRate])
    }
    
    private func resetUserDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
}
