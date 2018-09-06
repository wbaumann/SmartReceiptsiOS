//
//  ReceiptActionsModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxTest
import RxSwift
import XCTest

class ReceiptActionsModuleTest: XCTestCase {
    
    var presenter: ReceiptActionsPresenter!
    var interactor: MockReceiptActionsInteractor!
    var router: MockReceiptActionsRouter!
    
    var trip: WBTrip?
    
    override func setUp() {
        super.setUp()
        
        let p = ReceiptActionsPresenter(receipt: WBReceipt())
        
        var module = AppModules.receiptActions.build()
        module.injectMock(presenter: p)
        module.injectMock(interactor: MockReceiptActionsInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockReceiptActionsRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! ReceiptActionsPresenter
        interactor = module.interactor as! MockReceiptActionsInteractor
        router = module.router as! MockReceiptActionsRouter
        
        configureStubs()
        presenter.configureSubscribers()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.close().thenDoNothing()
            mock.openCopy(receipt: WBReceipt()).thenDoNothing()
            mock.openMove(receipt: WBReceipt()).thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.attachAppInputFile(to: WBReceipt()).then({ _ in true })
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter.swapUpTap.onNext(())
        presenter.swapDownTap.onNext(())
        presenter.copyTap.onNext(())
        presenter.moveTap.onNext(())
        presenter.handleAttachTap.onNext(())
        presenter.viewImageTap.onNext(())
        
        verify(router, times(4)).close()
        verify(router).openCopy(receipt: WBReceipt())
        verify(router).openMove(receipt: WBReceipt())
    }
    
    func testPresenterToInteractor() {
        presenter.handleAttachTap.onNext(())
        verify(interactor).attachAppInputFile(to: WBReceipt())
    }
}
