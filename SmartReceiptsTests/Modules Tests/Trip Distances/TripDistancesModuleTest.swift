//
//  TripDistancesModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import XCTest
import Viperit

class TripDistancesModuleTest: XCTestCase {
    
    var presenter: MockTripDistancesPresenter!
    var interactor: MockTripDistancesInteractor!
    
    var hasDistance = true
    
    override func setUp() {
        super.setUp()
        
        let p = TripDistancesPresenter()
        let i = TripDistancesInteractor()
        
        var module = Module.build(AppModules.tripDistances)
        
        module.injectMock(presenter: MockTripDistancesPresenter().spy(on: p))
        module.injectMock(interactor: MockTripDistancesInteractor().spy(on: i))
        
        presenter = module.presenter as! MockTripDistancesPresenter
        interactor = module.interactor as! MockTripDistancesInteractor
        
        // Connect Mock & Real
        p._interactor = interactor
        i._presenter = presenter
        
        configureStubs()
    }
    
    func configureStubs() {
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
    
    func testPresenterToInteractor() {
        presenter.delete(distance: Distance())
        XCTAssertFalse(hasDistance)
    }
}
