//
//  ReceiptColumnExchangedPriceTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class ReceiptColumnExchangedPriceTests: XCTestCase {
    fileprivate let trip = WBTrip()
    fileprivate var receipt: WBReceipt!
    fileprivate let column = ReceiptColumnExchangedPrice()
    
    override func setUp() {
        super.setUp()

        trip.defaultCurrency = WBCurrency(forCode: "EUR")
        
        receipt = WBReceipt()
        receipt.trip = trip
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "USD")
    }
    
    func testNoExchangeRate() {
        receipt.exchangeRate = nil
        XCTAssertEqual("", column.value(from: receipt, forCSV: false))
        XCTAssertEqual("", column.value(from: receipt, forCSV: true))
    }
    
    func testNegativeExchangeRate() {
        receipt.exchangeRate = .minusOne()
        XCTAssertEqual("", column.value(from: receipt, forCSV: false))
        XCTAssertEqual("", column.value(from: receipt, forCSV: true))
    }
    
    func testExchangedPriceCSV() {
        receipt.exchangeRate = NSDecimalNumber(string: "0.1")
        XCTAssertEqual("1.20", column.value(from: receipt, forCSV: true))
    }
    
    func testExchangedPricePDF() {
        receipt.exchangeRate = NSDecimalNumber(string: "0.1")
        XCTAssertEqual("€1.20", column.value(from: receipt, forCSV: false))
    }
    
    func testNoExchangeNeeded() {
        receipt.setPrice(NSDecimalNumber(string: "1"), currency: "EUR")
        XCTAssertEqual("€1.00", column.value(from: receipt, forCSV: false))
        XCTAssertEqual("1.00", column.value(from: receipt, forCSV: true))
    }
}
