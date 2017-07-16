//
//  ColumnsModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import XCTest

class ColumnsModuleTest: XCTestCase {
    
    var presenter: ColumnsPresenter!
    var interactor: MockColumnsInteractor!
    var router: MockColumnsRouter!
    
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = ColumnsPresenter()
        let i = ColumnsInteractor()
        let r = ColumnsRouter()
        
        var module = AppModules.columns.build()
        module.injectMock(presenter: p)
        module.injectMock(interactor: MockColumnsInteractor().spy(on: i))
        module.injectMock(router: MockColumnsRouter().spy(on: r))
        
        presenter = module.presenter as! ColumnsPresenter
        interactor = module.interactor as! MockColumnsInteractor
        router = module.router as! MockColumnsRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        i._presenter = presenter
        r._presenter = presenter
        
        configureStubs()
    }
    
    func configureStubs() {
        
        stub(interactor) { mock in
            mock.columns(forCSV: true).thenCallRealImplementation()
            mock.update(columns: [Column](), forCSV: true).thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
    
    }
    
    func testPresenterToInteractor() {
        presenter.setupView(data: true)
        verify(interactor).columns(forCSV: true)
        
        presenter.viewIsAboutToDisappear()
        verify(interactor).update(columns: [Column](), forCSV: true)
    }
    
}
