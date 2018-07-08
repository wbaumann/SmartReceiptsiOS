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
        
        let p = ReceiptMoveCopyPresenter()
        let i = ReceiptMoveCopyInteractor()
        let r = ReceiptMoveCopyRouter()
        
        var module = AppModules.receiptMoveCopy.build()
        module.injectMock(presenter: MockReceiptMoveCopyPresenter().spy(on: p))
        module.injectMock(interactor: MockReceiptMoveCopyInteractor().spy(on: i))
        module.injectMock(router: MockReceiptMoveCopyRouter().spy(on: r))
        
        presenter = module.presenter as! MockReceiptMoveCopyPresenter
        interactor = module.interactor as! MockReceiptMoveCopyInteractor
        router = module.router as! MockReceiptMoveCopyRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        i._presenter = presenter
        r._presenter = presenter
        
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
        
        presenter.isCopyOrMove = true
        presenter.tripTapSubject.onNext(WBTrip())
        
        presenter.isCopyOrMove = false
        presenter.tripTapSubject.onNext(WBTrip())
        
        verify(router, times(2)).close()
    }
    
}
