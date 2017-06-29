//
//  DistanceTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest

class DistanceTests: XCTestCase {
    
    var distance: Distance!
    
    override func setUp() {
        super.setUp()
        distance = Distance(trip: WBTrip(),
                        distance: NSDecimalNumber(decimal: 100),
                            rate: Price(amount: NSDecimalNumber(decimal: 10),
                        currency: Currency.currency(forCode: "USD")),
                        location: "LA",
                            date: Date(),
                        timeZone: TimeZone.current,
                         comment: "Comment")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCopy() {
        let copy = distance.copy() as! Distance
        XCTAssertFalse(copy === distance)
        XCTAssertTrue(copy == distance)
    }
    
    func testTotalRate() {
        let total = distance.totalRate()
        XCTAssertTrue(total.amount.doubleValue == 1000)
        XCTAssertTrue(total.currency.code == "USD")
    }
    
}
