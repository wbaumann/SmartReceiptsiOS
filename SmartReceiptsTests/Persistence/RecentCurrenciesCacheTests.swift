//
//  RecentCurrenciesCacheTests.swift
//  SmartReceipts
//
//  Created by Victor on 4/13/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import XCTest
@testable import SmartReceipts

class RecentCurrenciesCacheTests: SmartReceiptsTestsBase {
    
    private var trip: WBTrip!
    private var currencyCodes = [String]()
    
    override func setUp() {
        super.setUp()
        
        trip = db.createTestTrip()
        currencyCodes = ["USD", "EUR", "UAH"]
    }
    
    func testRecentCurrenciesCache() {
        XCTAssertEqual(RecentCurrenciesCache.shared.cachedCurrencyCodes, [], "Cache should be empty here")
        
        // Test that cache is 'updatable'
        
        // populate records:
        for aCode in currencyCodes {
            insertReceipt(currencyCode: aCode)
        }
        
        let cacheUpdatedExpectation = expectation(description: "RecentCurrenciesCache has been updated with codes \(currencyCodes)")
        
        // wait some time as this is async call without completion handlers
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            RecentCurrenciesCache.shared.updateInDatabase(database: self.db)
            let cachedCodes = RecentCurrenciesCache.shared.cachedCurrencyCodes
            XCTAssertEqual(cachedCodes.sorted(), self.currencyCodes.sorted(), "Cache contains \(self.currencyCodes)")
            cacheUpdatedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            if error != nil {
                XCTFail("timeout")
            }
        }
        
    }
    
    private func insertReceipt(currencyCode: String) {
        db.insertTestReceipt([ReceiptsTable.Column.Parent: trip, ReceiptsTable.Column.Price: 42, ReceiptsTable.Column.ISO4217: currencyCode, ReceiptsTable.Column.ExchangeRate: 0])
    }
    
}
