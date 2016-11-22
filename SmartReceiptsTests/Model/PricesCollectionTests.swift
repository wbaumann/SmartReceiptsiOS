//
//  PricesCollectionTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class PricesCollectionTests: XCTestCase {
    fileprivate var collection: PricesCollection!
    
    override func setUp() {
        super.setUp()

        collection = PricesCollection()
    }
    
    func testSingleCurrencyAdd() {
        collection.addPrice(Price(amount: NSDecimalNumber(string: "10"), currencyCode: "USD"))
        collection.addPrice(Price(amount: NSDecimalNumber(string: "20"), currencyCode: "USD"))
        collection.addPrice(Price(amount: NSDecimalNumber(string: "30"), currencyCode: "USD"))
        
        let expected = Price(amount: NSDecimalNumber(string: "60"), currencyCode: "USD")
        XCTAssertEqual(expected.currencyFormattedPrice(), collection.currencyFormattedPrice())
    }
    
    func testSingleCurrencyAddRemove() {
        collection.addPrice(Price(amount: NSDecimalNumber(string: "10"), currencyCode: "USD"))
        collection.subtractPrice(Price(amount: NSDecimalNumber(string: "5"), currencyCode: "USD"))
        collection.addPrice(Price(amount: NSDecimalNumber(string: "20"), currencyCode: "USD"))
        collection.subtractPrice(Price(amount: NSDecimalNumber(string: "10"), currencyCode: "USD"))
        
        let expected = Price(amount: NSDecimalNumber(string: "15"), currencyCode: "USD")
        XCTAssertEqual(expected.currencyFormattedPrice(), collection.currencyFormattedPrice())
    }
    
    func testMultiCurrencyAdd() {
        collection.addPrice(Price(amount: NSDecimalNumber(string: "10"), currencyCode: "USD"))
        collection.addPrice(Price(amount: NSDecimalNumber(string: "20"), currencyCode: "EUR"))
        collection.addPrice(Price(amount: NSDecimalNumber(string: "30"), currencyCode: "USD"))
        collection.addPrice(Price(amount: NSDecimalNumber(string: "40"), currencyCode: "EUR"))
        
        let expectedEUR = Price(amount: NSDecimalNumber(string: "60"), currencyCode: "EUR")
        let expectedUSD = Price(amount: NSDecimalNumber(string: "40"), currencyCode: "USD")
        
        let expectedResult = [expectedEUR.currencyFormattedPrice(), expectedUSD.currencyFormattedPrice()].joined(separator: "; ")
        XCTAssertEqual(expectedResult, collection.currencyFormattedPrice())
    }
}
