//
//  PriceTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class WBReceiptTests: XCTestCase {
    fileprivate let trip = WBTrip()
    fileprivate var receipt: WBReceipt!
    
    override func setUp() {
        super.setUp()
        
        trip.defaultCurrency = WBCurrency(forCode: "EUR")
        receipt = WBReceipt()
        receipt.trip = trip
    }
    
    func testNoExchangeRateFormatting() {
        receipt.setPrice(NSDecimalNumber(orZero: "10"), currency: "USD")
        XCTAssertEqual("", receipt.exchangeRateAsString())
    }
    
    func testZeroExchangeRateFormatting() {
        receipt.setPrice(NSDecimalNumber(orZero: "10"), currency: "USD")
        receipt.exchangeRate = NSDecimalNumber.zero
        XCTAssertEqual("", receipt.exchangeRateAsString())
    }
    
    func testNegativeExchangeRateFormatting() {
        receipt.setPrice(NSDecimalNumber(orZero: "10"), currency: "USD")
        receipt.exchangeRate = NSDecimalNumber(orZero: "-10")
        XCTAssertEqual("", receipt.exchangeRateAsString())
    }
    
    func testExchangeRateFormatting() {
        receipt.setPrice(NSDecimalNumber(orZero: "10"), currency: "USD")
        receipt.exchangeRate = NSDecimalNumber(orZero: "0.1234")
        XCTAssertEqual("0.1234", receipt.exchangeRateAsString())
    }
    
    func testSameCurrencyExchangeRateFormatting() {
        receipt.setPrice(NSDecimalNumber(orZero: "10"), currency: "EUR")
        XCTAssertEqual("1", receipt.exchangeRateAsString())
    }
}
