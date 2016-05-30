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
    private let trip = WBTrip()
    private var receipt: WBReceipt!
    private let column = ReceiptColumnExchangedPrice()
    
    override func setUp() {
        super.setUp()

        trip.defaultCurrency = WBCurrency(forCode: "EUR")
        
        receipt = WBReceipt()
        receipt.trip = trip
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "USD")
    }
    
    func testNoExchangeRate() {
        receipt.exchangeRate = nil
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testNegativeExchangeRate() {
        receipt.exchangeRate = .MinusOne
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testExchangedPriceCSV() {
        receipt.exchangeRate = NSDecimalNumber(string: "0.1")
        XCTAssertEqual("1.20", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testExchangedPricePDF() {
        receipt.exchangeRate = NSDecimalNumber(string: "0.1")
        XCTAssertEqual("€1.20", column.valueFromReceipt(receipt, forCSV: false))
    }
}
