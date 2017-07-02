//
//  EditReceiptModuleTest.swift
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

class EditReceiptModuleTest: XCTestCase {
    
    var presenter: EditReceiptPresenter!
    var interactor: MockEditReceiptInteractor!
    var router: MockEditReceiptRouter!
    
    var trip: WBTrip?
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = EditReceiptPresenter()
        let i = EditReceiptInteractor()
        let r = EditReceiptRouter()
        
        var module = Module.build(AppModules.editReceipt)
        module.injectMock(presenter: p)
        module.injectMock(interactor: MockEditReceiptInteractor().spy(on: i))
        module.injectMock(router: MockEditReceiptRouter().spy(on: r))
        
        presenter = module.presenter as! EditReceiptPresenter
        interactor = module.interactor as! MockEditReceiptInteractor
        router = module.router as! MockEditReceiptRouter
        
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
            mock.openSettings().thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.configureSubscribers().thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter.viewHasLoaded()
        presenter.settingsTap.onNext()
        presenter.close()
        
        verify(router).openSettings()
        verify(router).close()
    }
    
    func testPresenterToInteractor() {
        presenter.viewHasLoaded()
        
        verify(interactor).configureSubscribers()
    }
}
