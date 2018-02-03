//
//  PurchaseServiceTest.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 03/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import Cuckoo

class PurchaseServiceTest: XCTestCase {
    
    var purchaseService: MockPurchaseService!
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        purchaseService = MockPurchaseService().spy(on: PurchaseService())
        
        stub(purchaseService) { mock in
            mock.appStoreReceipt().then({ "qwerty" })
        }
    }
    
    func configureStubs() {
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessSent() {
        let receiptString = purchaseService.appStoreReceipt()!
        
        stub(purchaseService) { mock in
            mock.sendReceipt().then { UserDefaults.standard.set(true, forKey: receiptString) }
        }
        
        XCTAssertFalse(purchaseService.isReceiptSent(receiptString))
        purchaseService.sendReceipt()
        XCTAssertTrue(purchaseService.isReceiptSent(receiptString))
    }
    
    func testFailSent() {
        let receiptString = purchaseService.appStoreReceipt()!
        
        stub(purchaseService) { mock in
            mock.sendReceipt().then { UserDefaults.standard.set(false, forKey: receiptString) }
        }
        
        XCTAssertFalse(purchaseService.isReceiptSent(receiptString))
        purchaseService.sendReceipt()
        XCTAssertFalse(purchaseService.isReceiptSent(receiptString))
    }
    
}
