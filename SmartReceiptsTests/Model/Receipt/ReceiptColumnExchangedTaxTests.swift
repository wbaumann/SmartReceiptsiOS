//
//  ReceiptColumnExchangedTaxTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class ReceiptColumnExchangedTaxTests: XCTestCase {
    private let trip = WBTrip()
    private var receipt: WBReceipt!
    private let column = ReceiptColumnExchangedTax()

    override func setUp() {
        super.setUp()

        trip.defaultCurrency = WBCurrency(forCode: "EUR")
        
        receipt = WBReceipt()
        receipt.trip = trip
        receipt.setPrice(NSDecimalNumber(string: "12"), currency: "USD")
        receipt.setTax(NSDecimalNumber(string: "1.2"))
    }
    
    func testNoTax() {
        receipt.setTax(.zero())
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testNoExchangerate() {
        receipt.exchangeRate = nil
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testNegativeExchangeRate() {
        receipt.exchangeRate = .minusOne()
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testExportToCSV() {
        receipt.exchangeRate = NSDecimalNumber(string: "2")
        XCTAssertEqual("2.40", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testExportToPDF() {
        receipt.exchangeRate = NSDecimalNumber(string: "2")
        XCTAssertEqual("€2.40", column.valueFromReceipt(receipt, forCSV: false))
    }
    
    func testNoExchangeNeeded() {
        receipt.setPrice(NSDecimalNumber(string: "100"), currency: "EUR")
        receipt.exchangeRate = NSDecimalNumber(string: "2")

        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
    }
}
