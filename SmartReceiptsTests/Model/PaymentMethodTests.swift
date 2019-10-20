//
//  PaymentMethodTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts

import XCTest

class PaymentMethodTests: SmartReceiptsTestsBase {
    
    var paymentMethod: PaymentMethod!
    
    override func setUp() {
        super.setUp()
        paymentMethod = PaymentMethod.defaultMethod(db)
        createTestDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultMethod() {
        paymentMethod = PaymentMethod.defaultMethod(db)
        XCTAssertTrue(paymentMethod != nil)
    }
    
    func testEqualPaymentMethod() {
        let cashMethodName = "Cash"
        XCTAssertTrue(paymentMethod.method == cashMethodName)
        
        let cashMethod = PaymentMethod(objectId: 100, method: cashMethodName)
        let cardMethod = PaymentMethod(objectId: 200, method: "Card")
        
        XCTAssertTrue(paymentMethod == cashMethod)
        XCTAssertFalse(paymentMethod == cardMethod)
    }
    
    func testPresentedValue() {
        let methodName = "Bitcoin"
        let bitcoinMethod = PaymentMethod(objectId: 100, method: methodName)
        
        XCTAssertFalse(paymentMethod.presentedValue() == methodName)
        XCTAssertTrue(bitcoinMethod.presentedValue() == methodName)
    }
    
}
