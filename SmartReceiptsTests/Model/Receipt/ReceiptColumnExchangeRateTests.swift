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
    private var receipt: WBReceipt!
    private let column = ReceiptColumnExchangeRate()

    override func setUp() {
        super.setUp()

        receipt = WBReceipt()
    }
    
    func testNoExchangeRate() {
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testNegativeExchangeRate() {
        receipt.exchangeRate = .minusOne()
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("", column.valueFromReceipt(receipt, forCSV: true))
    }
    
    func testExchangeRateMoreNumbers() {
        receipt.exchangeRate = NSDecimalNumber(string: "0.123456")

        XCTAssertEqual("0.123456", column.valueFromReceipt(receipt, forCSV: false))
        XCTAssertEqual("0.123456", column.valueFromReceipt(receipt, forCSV: true))
    }
}
