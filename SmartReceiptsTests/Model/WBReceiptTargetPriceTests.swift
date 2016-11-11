//
//  WBReceiptTargetPriceTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class WBReceiptTargetPriceTests: XCTestCase {
    private let trip = WBTrip()
    private let receiptEUR = WBReceipt()
    private let receiptUSD = WBReceipt()
    
    override func setUp() {
        super.setUp()
        
        trip.defaultCurrency = WBCurrency(forCode: "USD")
        receiptEUR.trip = trip
        receiptEUR.setPrice(NSDecimalNumber(string: "12"), currency: "EUR")
        receiptEUR.exchangeRate = NSDecimalNumber(string: "0.1")
        
        receiptUSD.trip = trip
        receiptUSD.setPrice(NSDecimalNumber(string: "10"), currency: "USD")
    }
    
    func testSameCurrencyAsTrip() {
        let result = receiptUSD.targetPrice()
        XCTAssertEqual("$10.00", result.currencyFormattedPrice())
    }
    
    func testLargeCurrencies() {
        receiptUSD.setPrice(NSDecimalNumber(string: "10000"), currency: "USD")
        let result = receiptUSD.targetPrice()
        XCTAssertEqual("$10,000.00", result.currencyFormattedPrice())
        XCTAssertEqual("10000.00", result.amountAsString())
    }
    
    func testNoExchangeRate() {
        receiptEUR.exchangeRate = nil
        let result = receiptEUR.targetPrice()
        XCTAssertEqual("€12.00", result.currencyFormattedPrice())
    }
    
    func testInvalidExchangeRate() {
        receiptEUR.exchangeRate = .minusOne()
        let result = receiptEUR.targetPrice()
        XCTAssertEqual("€12.00", result.currencyFormattedPrice())
    }
    
    func testExchangedTarget() {
        let result = receiptEUR.targetPrice()
        XCTAssertEqual("$1.20", result.currencyFormattedPrice())
    }
}
