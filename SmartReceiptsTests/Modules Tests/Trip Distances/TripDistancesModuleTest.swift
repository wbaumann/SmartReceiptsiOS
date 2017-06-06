//
//  TripDistancesModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo

import XCTest
import Viperit


class TripDistancesModuleTest: XCTestCase {
    
    var presenter: MockTripDistancesPresenter!
    var interactor: MockTripDistancesInteractor!
    
    var hasDistance = true
    
    override func setUp() {
        super.setUp()
        var module = Module.build(AppModules.tripDistances)
        module.injectMock(presenter: MockTripDistancesPresenter())
        module.injectMock(interactor: MockTripDistancesInteractor())
        
        presenter = module.presenter as! MockTripDistancesPresenter
        interactor = module.interactor as! MockTripDistancesInteractor
        confugureStubs()
    }
    
    func confugureStubs() {
        stub(presenter) { mock in
            mock.delete(distance: Distance()).then({ distance in
                self.hasDistance = false
            })
        }
        
        stub(interactor) { mock in
            mock.delete(distance: Distance()).then({ distance in
                self.hasDistance = false
            })
        }
    }
    
    override func tearDown() {
        super.tearDown()
        hasDistance = true
    }
    
    func testInteractorDeleteDistance() {
        interactor.delete(distance: Distance())
        verify(interactor).delete(distance: Distance())
        XCTAssertFalse(hasDistance)
    }
    
    func testPresenterDeleteDistance() {
        presenter.delete(distance: Distance())
        verify(presenter).delete(distance: Distance())
        XCTAssertFalse(hasDistance)
    }
}
