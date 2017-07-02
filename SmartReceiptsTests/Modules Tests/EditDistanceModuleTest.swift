//
//  EditDistanceModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import XCTest

class EditDistanceModuleTest: XCTestCase {
    
    private var presenter: MockEditDistancePresenter!
    private var interactor: MockEditDistanceInteractor!
    private var router: MockEditDistanceRouter!
    
    var distanceSaved = false
    
    override func setUp() {
        super.setUp()
        
        let p = EditDistancePresenter()
        let i = EditDistanceInteractor()
        let r = EditDistanceRouter()
        
        var module = Module.build(AppModules.editDistance)
        module.injectMock(presenter: MockEditDistancePresenter().spy(on: p))
        module.injectMock(interactor: MockEditDistanceInteractor().spy(on: i))
        module.injectMock(router: MockEditDistanceRouter().spy(on: r))
        
        presenter = module.presenter as! MockEditDistancePresenter
        interactor = module.interactor as! MockEditDistanceInteractor
        router = module.router as! MockEditDistanceRouter
        
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
        
        stub(interactor) { mock in
            mock.save(distance: Distance(), asNewDistance: true).then({ (distance, update) in
                self.distanceSaved = true
            })
        }
    }
    
    override func tearDown() {
        super.tearDown()
        distanceSaved = false
    }
    
    func testPresenterToInteractor() {
        presenter.save(distance: Distance(), asNewDistance: true)
        XCTAssertTrue(distanceSaved)
    }
    
    func testPresenterToRouter() {
        presenter.close()
        verify(router).close()
    }
}
