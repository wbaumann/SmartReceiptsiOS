//
//  TripsModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import XCTest

class TripsModuleTest: XCTestCase {
    
    var presenter: MockTripsPresenter!
    var interactor: MockTripsInteractor!
    var router: MockTripsRouter!
    
    var trip: WBTrip? = WBTrip()
    var tripRouted = false
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        var module = AppModules.trips.build()
        module.injectMock(presenter: MockTripsPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockTripsInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockTripsRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! MockTripsPresenter
        interactor = module.interactor as! MockTripsInteractor
        router = module.router as! MockTripsRouter
        
        configureStubs()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.openAddTrip().thenDoNothing()
            mock.openSettings().thenDoNothing()
            mock.openNoTrips().thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.configureSubscribers().then {
                self.presenter.tripDeleteSubject.subscribe(onNext: { trip in
                    self.trip = nil
                }).disposed(by: self.bag)
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter._view.loadView()
        
        presenter.presentAddTrip()
        verify(router).openAddTrip()
        
        presenter.presentSettings()
        verify(router).openSettings()
    }
    
    func testPresenterToInteractor() {
        presenter._view.loadView()
        presenter.viewHasLoaded()
        
        verify(interactor).configureSubscribers()
        
        presenter.tripDeleteSubject.onNext(self.trip!)
        XCTAssertNil(self.trip)
    }
}
