//
//  EditDistanceModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo

import Viperit
import XCTest

class EditDistanceModuleTest: XCTestCase {
    
    private var presenter: MockEditDistancePresenter!
    private var interactor: MockEditDistanceInteractor!
    private var router: MockEditDistanceRouter!
    
    var distanceSaved = false
    
    override func setUp() {
        super.setUp()
        var module = Module.build(AppModules.editDistance)
        module.injectMock(presenter: MockEditDistancePresenter())
        module.injectMock(interactor: MockEditDistanceInteractor())
        module.injectMock(router: MockEditDistanceRouter())
        
        presenter = module.presenter as? MockEditDistancePresenter
        interactor = module.interactor as? MockEditDistanceInteractor
        router = module.router as? MockEditDistanceRouter
        configureStubs()
    }
    
    func configureStubs() {
        stub(presenter) { mock in
            mock.close().thenDoNothing()
        }
        
        stub(router) { mock in
            mock.close().thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.save(distance: Distance(), asNewDistance: true).then({ (distance, update) in
                self.distanceSaved = true
            })
        }
        
        stub(presenter) { mock in
            mock.save(distance: Distance(), asNewDistance: true).then({ (distance, update) in
                self.distanceSaved = true
            })
        }
    }
    
    override func tearDown() {
        super.tearDown()
        distanceSaved = false
    }
    
    func testRouterClose() {
        router.close()
        verify(router).close()
    }
    
    func testPresenterClose() {
        presenter.close()
        verify(presenter).close()
    }
    
    func testInteractorSaveDistance() {
        interactor.save(distance: Distance(), asNewDistance: true)
        verify(interactor).save(distance: Distance(), asNewDistance: true)
        XCTAssertTrue(distanceSaved)
    }
    
    func testPresenterSaveDistance() {
        presenter.save(distance: Distance(), asNewDistance: true)
        verify(presenter).save(distance: Distance(), asNewDistance: true)
        XCTAssertTrue(distanceSaved)
    }
}

extension Distance: Matchable {
    public var matcher: ParameterMatcher<Distance> {
        get {
            return ParameterMatcher(matchesFunction: { distance -> Bool in
                return self.objectId == distance.objectId
            })
        }
    }
}
