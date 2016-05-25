//
//  PriceTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class PriceTests: XCTestCase {
    func testNoExchangeRateFormatting() {
        let price = Price(amount: NSDecimalNumber(orZero: "10"), currencyCode: "USD")
        XCTAssertEqual("", price.exchangeRateAsString())
    }
    
    func testZeroExchangeRateFormatting() {
        let price = Price(amount: NSDecimalNumber(orZero: "10"), currencyCode: "USD")
        price.exchangeRate = NSDecimalNumber.zero()
        XCTAssertEqual("", price.exchangeRateAsString())
    }
    
    func testNegativeExchangeRateFormatting() {
        let price = Price(amount: NSDecimalNumber(orZero: "10"), currencyCode: "USD")
        price.exchangeRate = NSDecimalNumber(orZero: "-10")
        XCTAssertEqual("", price.exchangeRateAsString())
    }
    
    func testExchangeRateFormatting() {
        let price = Price(amount: NSDecimalNumber(orZero: "10"), currencyCode: "USD")
        price.exchangeRate = NSDecimalNumber(orZero: "0.1234")
        XCTAssertEqual("0.1234", price.exchangeRateAsString())
    }
}
