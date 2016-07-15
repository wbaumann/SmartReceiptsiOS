//
//  ReceiptColumnExchangeRateTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class ReceiptColumnExchangeRateTests: XCTestCase {
    private let trip = WBTrip()
    private var receipt: WBReceipt!
    private let column = ReceiptColumnExchangeRate()

    override func setUp() {
        super.setUp()

        trip.defaultCurrency = WBCurrency(forCode: "USD")
        receipt = WBReceipt()
        receipt.trip = trip
    }
    
    func testNoExchangeRateForSameCurrency() {
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "USD")
        XCTAssertEqual("1", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("1", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testNegativeExchangeRate() {
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "EUR")
        receipt.exchangeRate = .minusOne()
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testProvidedExchangeRateForSameCurrency() {
        // Note: This represents a scenario in which something got f'ed up... We should fail fast before here
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "USD")
        receipt.exchangeRate = NSDecimalNumber(string: "0.123456")
        
        XCTAssertEqual("1", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("1", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testExchangeRateForDifferentCurrency() {
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "EUR")
        receipt.exchangeRate = NSDecimalNumber(string: "0.123456")

        XCTAssertEqual("0.123456", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("0.123456", column.valueFromReceipt(receipt, forCSV: true))
    }
}
