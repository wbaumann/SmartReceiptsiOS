//
//  OCRConfigurationModuleTest.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 28/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import RxTest
import XCTest
import StoreKit

class OCRConfigurationModuleTest: XCTestCase {
    
    var presenter: MockOCRConfigurationPresenter!
    var interactor: MockOCRConfigurationInteractor!
    var router: MockOCRConfigurationRouter!
    
    let purchaseService = MockPurchaseService().spy(on: PurchaseService())
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = OCRConfigurationPresenter()
        let i = OCRConfigurationInteractor(purchaseService: purchaseService)
        let r = OCRConfigurationRouter()
        
        var module = AppModules.OCRConfiguration.build()
        module.injectMock(presenter: MockOCRConfigurationPresenter().spy(on: p))
        module.injectMock(interactor: MockOCRConfigurationInteractor().spy(on: i))
        module.injectMock(router: MockOCRConfigurationRouter().spy(on: r))
        
        presenter = module.presenter as! MockOCRConfigurationPresenter
        interactor = module.interactor as! MockOCRConfigurationInteractor
        router = module.router as! MockOCRConfigurationRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        p._view = module.view
        i._presenter = presenter
        r._presenter = presenter
        
        configureStubs()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func configureStubs() {
        stub(purchaseService) { mock in
            mock.requestProducts().thenReturn(Observable<SKProduct>.never())
            mock.purchase(prodcutID: "").thenReturn(Observable<SKPaymentTransaction>.never())
        }
    }
    
    func testInteractor() {
        _ = interactor.requestProducts()
        verify(purchaseService).requestProducts()
        
        _ = interactor.purchase(product: "")
        verify(purchaseService).purchase(prodcutID: "")
    }
}
