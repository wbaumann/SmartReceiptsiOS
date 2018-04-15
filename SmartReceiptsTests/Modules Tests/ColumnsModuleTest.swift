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
    let bag = DisposeBag()
    
    var presenter: MockColumnsPresenter!
    var interactor: MockColumnsInteractor!
    var router: MockColumnsRouter!
    
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = ColumnsPresenter()
        let i = ColumnsInteractor()
        let r = ColumnsRouter()
        
        var module = AppModules.columns.build()
        module.injectMock(presenter: MockColumnsPresenter().spy(on: p))
        module.injectMock(interactor: MockColumnsInteractor().spy(on: i))
        module.injectMock(router: MockColumnsRouter().spy(on: r))
        
        presenter = module.presenter as! MockColumnsPresenter
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
            mock.addColumn(Column(), isCSV: true).thenDoNothing()
            mock.removeColumn(Column(), isCSV: true).thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
    
    }
    
    func testPresenterToInteractor() {
        presenter.viewHasLoaded()
        presenter.addSubject.onNext(Column())
        presenter.removeSubject.onNext(Column())
        
        verify(interactor).addColumn(Column(), isCSV: true)
        verify(interactor).removeColumn(Column(), isCSV: true)
    }
    
}
