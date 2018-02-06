//
//  ReceiptsModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import RxTest
import XCTest

class ReceiptsModuleTest: XCTestCase {
    
    var presenter: ReceiptsPresenter!
    var interactor: MockReceiptsInteractor!
    var router: MockReceiptsRouter!
    
    var trip: WBTrip?
    let disposeBag = DisposeBag()
    let actionsPresneter = ReceiptActionsPresenter()
    
    override func setUp() {
        super.setUp()
        
        let p = ReceiptsPresenter()
        let i = ReceiptsInteractor()
        let r = ReceiptsRouter()
        
        var module = AppModules.receipts.build()
        module.injectMock(presenter: p)
        module.injectMock(interactor: MockReceiptsInteractor().spy(on: i))
        module.injectMock(router: MockReceiptsRouter().spy(on: r))
        
        presenter = module.presenter as! ReceiptsPresenter
        interactor = module.interactor as! MockReceiptsInteractor
        router = module.router as! MockReceiptsRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        i._presenter = presenter
        r._presenter = presenter
        
        configureStubs()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.openCreateReceipt().thenDoNothing()
            mock.openActions(receipt: WBReceipt()).then({ _ -> ReceiptActionsPresenter in
                return self.actionsPresneter
            })
            mock.openCreatePhotoReceipt().thenDoNothing()
            mock.openPDFViewer(for: WBReceipt()).thenDoNothing()
            mock.openImageViewer(for: WBReceipt()).thenDoNothing()
            mock.openImportReceiptFile().thenDoNothing()
            
        }
        
        stub(interactor) { mock in
            mock.swapUpReceipt(WBReceipt()).thenDoNothing()
            mock.swapDownReceipt(WBReceipt()).thenDoNothing()
            mock.distanceReceipts().then({ [WBReceipt]() })
            mock.titleSubtitle().then({ ("title", "subtitle") })
        
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter.setupView(data: WBTrip())
        
        presenter.createReceiptCameraSubject.onNext()
        presenter.importReceiptFileSubject.onNext()
        presenter.createReceiptTextSubject.onNext()
        
        verify(router).openCreatePhotoReceipt()
        verify(router).openImportReceiptFile()
        verify(router).openCreateReceipt()
    }
    
    func testPresenterToInteractor() {
        let ts = presenter.titleSubtitle
        XCTAssertTrue(ts.title == "title")
        XCTAssertTrue(ts.subtitle == "subtitle")
        
        presenter.viewHasLoaded()
        presenter.receiptActionsSubject.onNext(WBReceipt())
        
        actionsPresneter.swapUpTap.onNext()
        actionsPresneter.swapDownTap.onNext()
        
        verify(interactor).swapDownReceipt(WBReceipt())
        verify(interactor).swapUpReceipt(WBReceipt())
        verify(interactor).titleSubtitle()
    }
    
}
