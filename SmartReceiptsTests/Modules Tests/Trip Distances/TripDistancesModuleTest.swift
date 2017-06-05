//
//  TripDistancesModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable
import SmartReceipts

import XCTest
import Viperit


class TripDistancesModuleTest: SmartReceiptsTestsBase {
    
    private var presenter: TripDistancesPresenter?
    private var interactor: TripDistancesInteractor?
    
    override func setUp() {
        super.setUp()
        var module = Module.build(AppModules.tripDistances)
        module.injectMock(interactor: TripDistancesInteractor(database: db))
        
        presenter = module.presenter as? TripDistancesPresenter
        interactor = module.interactor as? TripDistancesInteractor
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterDeleteDistance() {
        let distance = db.insertTestDistance([AnyHashable: Any]())
        presenter?.delete(distance: distance)
    }
    
    func testInteractorDeleteDistance() {
        let distance = db.insertTestDistance([AnyHashable: Any]())
        interactor?.delete(distance: distance)
        
    }
}
