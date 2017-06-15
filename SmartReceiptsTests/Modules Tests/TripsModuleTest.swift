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
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = TripsPresenter()
        let i = TripsInteractor()
        let r = TripsRouter()
        
        var module = Module.build(AppModules.trips)
        module.injectMock(presenter: MockTripsPresenter().spy(on: p))
        module.injectMock(interactor: MockTripsInteractor().spy(on: i))
        module.injectMock(router: MockTripsRouter().spy(on: r))
        
        presenter = module.presenter as! MockTripsPresenter
        interactor = module.interactor as! MockTripsInteractor
        router = module.router as! MockTripsRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        p._view = module.view
        i._presenter = presenter
        r._presenter = presenter
        
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
                }).addDisposableTo(self.disposeBag)
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter.viewHasLoaded()
        
        presenter.presentAddTrip()
        verify(router).openAddTrip()
        
        presenter.presentSettings()
        verify(router).openSettings()
    
    }
    
    func testPresenterToInteractor() {
        presenter.viewHasLoaded()
        verify(interactor).configureSubscribers()
        
        presenter.tripDeleteSubject.onNext(self.trip!)
        XCTAssertNil(self.trip)
    }
}

extension WBTrip: Matchable {
    public var matcher: ParameterMatcher<WBTrip> {
        get {
            return ParameterMatcher(matchesFunction: { trip -> Bool in
                return self.isEqual(trip)
            })
        }
    }
}
