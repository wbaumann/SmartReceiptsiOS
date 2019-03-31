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
import SwiftyStoreKit
import StoreKit

class OCRConfigurationModuleTest: XCTestCase {
    
    var presenter: MockOCRConfigurationPresenter!
    var interactor: MockOCRConfigurationInteractor!
    var router: MockOCRConfigurationRouter!
    
    let purchaseService = MockPurchaseService().withEnabledSuperclassSpy()
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        var module = AppModules.OCRConfiguration.build()
        
        module.injectMock(presenter: MockOCRConfigurationPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockOCRConfigurationInteractor(purchaseService: purchaseService).withEnabledSuperclassSpy())
        module.injectMock(router: MockOCRConfigurationRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as? MockOCRConfigurationPresenter
        interactor = module.interactor as? MockOCRConfigurationInteractor
        router = module.router as? MockOCRConfigurationRouter
        
        configureStubs()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func configureStubs() {
        stub(purchaseService) { mock in
            mock.requestProducts().thenReturn(Observable<SKProduct>.never())
            mock.purchase(prodcutID: "").thenReturn(Observable<PurchaseDetails>.never())
        }
    }
    
    func testInteractor() {
        _ = interactor.requestProducts()
        verify(purchaseService).requestProducts()
        
        _ = interactor.purchase(product: "")
        verify(purchaseService).purchase(prodcutID: "")
    }
}
