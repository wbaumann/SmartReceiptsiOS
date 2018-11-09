//
//  ReceiptMoveCopyModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import XCTest

class ReceiptMoveCopyModuleTest: XCTestCase {
    
    var presenter: MockReceiptMoveCopyPresenter!
    var interactor: MockReceiptMoveCopyInteractor!
    var router: MockReceiptMoveCopyRouter!
    
    var trip: WBTrip?
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        var module = AppModules.receiptMoveCopy.build()
        module.injectMock(presenter: MockReceiptMoveCopyPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockReceiptMoveCopyInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockReceiptMoveCopyRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! MockReceiptMoveCopyPresenter
        interactor = module.interactor as! MockReceiptMoveCopyInteractor
        router = module.router as! MockReceiptMoveCopyRouter
        
        configureStubs()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.close().thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter.close()
        verify(router).close()
    }
    
    func testPresenterToInteractor() {
        interactor.configureSubscribers()
        presenter.receipt = WBReceipt()
        
        presenter.isCopy = true
        presenter.tripTapSubject.onNext(WBTrip())
        
        presenter.isCopy = false
        presenter.tripTapSubject.onNext(WBTrip())
        
        verify(router, times(2)).close()
    }
    
}
