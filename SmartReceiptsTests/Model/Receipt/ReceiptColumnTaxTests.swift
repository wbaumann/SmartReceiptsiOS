//
//  ReceiptColumnTaxTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class ReceiptColumnTaxTests: XCTestCase {
    fileprivate var receipt: WBReceipt!
    fileprivate let column = ReceiptColumnTax()
    
    override func setUp() {
        super.setUp()

        receipt = WBReceipt()
        receipt.setPrice(NSDecimalNumber(string: "1"), currency: "USD")
        receipt.setTax(NSDecimalNumber(string: "10"))
    }
    
    func testNoTax() {
        receipt.setTax(.zero)
        XCTAssertEqual("", column.value(from: receipt, forCSV: false))
        XCTAssertEqual("", column.value(from: receipt, forCSV: true))
    }
    
    func testCSVExport() {
        XCTAssertEqual("10.00", column.value(from: receipt, forCSV: true))
    }
    
    func testPDFExport() {
        XCTAssertEqual("$10.00", column.value(from: receipt, forCSV: false))
    }
}
