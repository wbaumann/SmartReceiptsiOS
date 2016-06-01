//
//  TripsFetchedModelAdapterTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class TripsFetchedModelAdapterTests: SmartReceiptsTestsBase, RefreshTripPriceHandler {
    private var trip: WBTrip!
    private let preferences = WBPreferencesTestHelper()
    
    override func setUp() {
        super.setUp()

        trip = db.createTestTrip()
        addReceipt(NSDecimalNumber(string: "10"))
        addReceipt(NSDecimalNumber(string: "5"))
        
        // Distance 10, currency USD
        db.insertTestDistance([DistanceTable.Column.Parent: trip, DistanceTable.Column.Rate: NSDecimalNumber(string: "1")])
        
        preferences.createPreferencesBackup()
        
        WBPreferences.setTheDistancePriceBeIncludedInReports(false)
    }
    
    override func tearDown() {
        preferences.restorePreferencesBackup()
        
        super.tearDown()
    }
    
    func testAddingSameCurrencyReceipts() {
        db.inDatabase() {
            database in

            self.refreshPriceForTrip(self.trip, inDatabase: database)
        }
        
        XCTAssertEqual("$15.00", trip.formattedPrice())
    }
    
    func testAddingMultipleCurrencies() {
        addReceipt(NSDecimalNumber(string: "12"), currency: "EUR", exchangeRate: NSDecimalNumber(string: "0.1"))

        db.inDatabase() {
            database in
            
            self.refreshPriceForTrip(self.trip, inDatabase: database)
        }
        
        XCTAssertEqual("$16.20", trip.formattedPrice())
    }

    func testAddingMultipleCurrenciesWithoutExchangeRate() {
        addReceipt(NSDecimalNumber(string: "12"), currency: "EUR")
        
        db.inDatabase() {
            database in
            
            self.refreshPriceForTrip(self.trip, inDatabase: database)
        }
        
        XCTAssertEqual("€12.00; $15.00", trip.formattedPrice())
    }

    func testWithDistances() {
        WBPreferences.setTheDistancePriceBeIncludedInReports(true)
        
        db.inDatabase() {
            database in
            
            self.refreshPriceForTrip(self.trip, inDatabase: database)
        }
        
        XCTAssertEqual("$25.00", trip.formattedPrice())
    }
    
    private func addReceipt(amount: NSDecimalNumber, currency: String = "USD", exchangeRate: NSDecimalNumber = .zero()) {
        db.insertTestReceipt([ReceiptsTable.Column.Parent: trip, ReceiptsTable.Column.Price: amount, ReceiptsTable.Column.ISO4217: currency, ReceiptsTable.Column.ExchangeRate: exchangeRate])
    }
}
