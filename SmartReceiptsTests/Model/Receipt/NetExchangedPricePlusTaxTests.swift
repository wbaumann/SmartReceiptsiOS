//
//  NetExchangedPricePlusTaxTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class NetExchangedPricePlusTaxTests: XCTestCase {
    private let trip = WBTrip()
    private var receiptEUR: WBReceipt!
    private var receiptUSD: WBReceipt!
    private let column = ReceiptColumnNetExchangedPricePlusTax()
    private let preferences = WBPreferencesTestHelper()

    override func setUp() {
        super.setUp()

        preferences.createPreferencesBackup()
        
        trip.defaultCurrency = WBCurrency(forCode: "USD")
        
        receiptEUR = WBReceipt()
        receiptEUR.trip = trip
        receiptEUR.setPrice(NSDecimalNumber(string: "10"), currency: "EUR")
        receiptEUR.setTax(NSDecimalNumber(string: "1"))
        receiptEUR.exchangeRate = NSDecimalNumber(string: "0.5")
        
        receiptUSD = WBReceipt()
        receiptUSD.trip = trip
        receiptUSD.setPrice(NSDecimalNumber(string: "20"), currency: "USD")
        receiptUSD.setTax(NSDecimalNumber(string: "2"))
        
        WBPreferences.setEnteredPricePreTax(true)
    }
    
    override func tearDown() {
        preferences.restorePreferencesBackup()
        
        super.tearDown()
    }
    
    func testNoTax() {
        receiptEUR.setTax(.zero())
        XCTAssertEqual("5.00", column.valueFromReceipt(receiptEUR, forCSV: true))
        XCTAssertEqual("$5.00", column.valueFromReceipt(receiptEUR, forCSV: false))
    }
    
    func testNoExchange() {
        receiptEUR.exchangeRate = nil
        XCTAssertEqual("", column.valueFromReceipt(receiptEUR, forCSV: true))
        XCTAssertEqual("", column.valueFromReceipt(receiptEUR, forCSV: false))
    }
    
    func testPriceWithTax() {
        WBPreferences.setEnteredPricePreTax(false)
        
        XCTAssertEqual("5.00", column.valueFromReceipt(receiptEUR, forCSV: true))
    }
    
    func testPriceWithoutTax() {
        XCTAssertEqual("5.50", column.valueFromReceipt(receiptEUR, forCSV: true))
    }
    
    func testCSVFormat() {
        XCTAssertEqual("5.50", column.valueFromReceipt(receiptEUR, forCSV: true))
    }
    
    func testPDFFormat() {
        XCTAssertEqual("$5.50", column.valueFromReceipt(receiptEUR, forCSV: false))
    }
    
    func testNoConversionNeede() {
        XCTAssertEqual("", column.valueFromReceipt(receiptUSD, forCSV: true))
        XCTAssertEqual("", column.valueFromReceipt(receiptUSD, forCSV: false))
    }
}
