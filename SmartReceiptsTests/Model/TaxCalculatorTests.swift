//
//  TaxCalculatorTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts

import XCTest
import RxTest

class TaxCalculatorTests: XCTestCase {
    
    let taxCalculator = TaxCalculator()
    
    override func setUp() {
        super.setUp()
        WBPreferences.setDefaultTaxPercentage(12.5)
        WBPreferences.setEnteredPricePreTax(true)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCalculator() {
        let scheduler = TestScheduler(initialClock: 0)
        
        _ = scheduler.createHotObservable([
            next(100, 100.0),
            next(200, 0),
            next(300, nil),
            next(400, 200.0),
            next(500, -100.0)
        
        ]).bind(to:taxCalculator.priceSubject)
        let observer = scheduler.createObserver(String.self)
        
        _ = taxCalculator.taxSubject.bind(to: observer)
        scheduler.start()
        
        
        let correctMessages = [
            next(100, "12.50"),
            next(200, "0.00"),
            next(300, ""),
            next(400, "25.00"),
            next(500, "-12.50")
        ]
        
        XCTAssertEqual(correctMessages, observer.events)
    }
}
