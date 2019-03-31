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
        
        var module = AppModules.editDistance.build()
        module.injectMock(presenter: MockEditDistancePresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockEditDistanceInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockEditDistanceRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as? MockEditDistancePresenter
        interactor = module.interactor as? MockEditDistanceInteractor
        router = module.router as? MockEditDistanceRouter
        
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
