//
//  EditDistanceModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable
import SmartReceipts

import Viperit
import XCTest

class TestEditDistanceRouter: EditDistanceRouter {
    var isClosed = false
    
    override func close() {
        isClosed = true
    }
}

class EditDistanceModuleTest: SmartReceiptsTestsBase {
    
    private var presenter: EditDistancePresenter?
    private var interactor: EditDistanceInteractor?
    private var router: TestEditDistanceRouter?
    
    override func setUp() {
        super.setUp()
        var module = Module.build(AppModules.editDistance)
        module.injectMock(interactor: EditDistanceInteractor(database: db))
        
        router = TestEditDistanceRouter()
        module.injectMock(router: router!)
        
        presenter = module.presenter as? EditDistancePresenter
        interactor = module.interactor as? EditDistanceInteractor
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterSaveDistance() {
        
    // Check with incorrect distance
        interactor?.save(distance: Distance(), asNewDistance: false)
        XCTAssertEqual(false, router?.isClosed)
        
    // Check with correct distance
        let distance = db.insertTestDistance([AnyHashable : Any]())
        presenter?.save(distance: distance, asNewDistance: false)
        XCTAssertEqual(true, router?.isClosed)
        router?.isClosed = false
    }
    
    func testInteractorSaveDistance() {
        
    // Check with incorrect distance
        interactor?.save(distance: Distance(), asNewDistance: false)
        XCTAssertEqual(false, router?.isClosed)
        
    // Check with correct distance
        let distance = db.insertTestDistance([AnyHashable : Any]())
        interactor?.save(distance: distance, asNewDistance: false)
        XCTAssertEqual(true, router?.isClosed)
        router?.isClosed = false
    }
}
