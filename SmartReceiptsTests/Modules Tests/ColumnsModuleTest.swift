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
    
    let testColumn = Column(type: 0, name: "test")!
    
    override func setUp() {
        super.setUp()
    
        var module = AppModules.columns.build()
        module.injectMock(interactor: MockColumnsInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockColumnsRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! ColumnsPresenter
        interactor = module.interactor as! MockColumnsInteractor
        router = module.router as! MockColumnsRouter
        
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
