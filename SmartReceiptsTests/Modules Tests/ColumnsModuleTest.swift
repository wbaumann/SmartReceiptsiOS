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
    
    var presenter: ColumnsPresenter!
    var interactor: MockColumnsInteractor!
    var router: MockColumnsRouter!
    
    let testColumn = Column(index: 0, name: "test")!
    
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
            mock.addColumn(testColumn, isCSV: false).thenDoNothing()
            mock.removeColumn(testColumn, isCSV: false).thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
    
    }
    
    func testPresenterToInteractor() {
        presenter.viewHasLoaded()
        
        presenter.addSubject.onNext(testColumn)
        presenter.removeSubject.onNext(testColumn)
        
        verify(interactor).addColumn(testColumn, isCSV: false)
        verify(interactor).removeColumn(testColumn, isCSV: false)
    }
    
}
