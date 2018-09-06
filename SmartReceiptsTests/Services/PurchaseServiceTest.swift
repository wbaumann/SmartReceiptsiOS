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
import RxSwift

class PurchaseServiceTest: XCTestCase {
    
    var purchaseService: MockPurchaseService!
    var purchaseServiceSuccess = PurchaseServiceCustomMockSuccess()
    var purchaseServiceFail = PurchaseServiceCustomMockFail()
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        purchaseService = MockPurchaseService().withEnabledSuperclassSpy()
        configureStubs()
    }
    
    func configureStubs() {
        stub(purchaseService) { mock in
            mock.appStoreReceipt().then({ "qwerty" })
            
            mock.validateSubscription().then({ () -> Observable<SubscriptionValidation> in
                return Observable<SubscriptionValidation>.just((true, Date()))
            })
        }
    }
    
    override func tearDown() {
        purchaseService.resetCache()
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
    
    func testValidSubscription() {
        XCTAssertFalse(purchaseServiceSuccess.hasValidSubscriptionValue())
        purchaseServiceSuccess.cacheSubscriptionValidation()
        XCTAssertTrue(purchaseServiceSuccess.hasValidSubscriptionValue())
    }
    
    func testResetCache() {
        XCTAssertFalse(purchaseServiceSuccess.hasValidSubscriptionValue())
        purchaseServiceSuccess.cacheSubscriptionValidation()
        XCTAssertTrue(purchaseServiceSuccess.hasValidSubscriptionValue())
        purchaseServiceSuccess.resetCache()
        XCTAssertFalse(purchaseServiceSuccess.hasValidSubscriptionValue())
    }
    
    func testExpiredSubscription() {
        XCTAssertFalse(purchaseServiceFail.hasValidSubscriptionValue())
        purchaseServiceFail.cacheSubscriptionValidation()
        XCTAssertFalse(purchaseServiceFail.hasValidSubscriptionValue())
    }
    
}
