//
//  EditTripModuleTest.swift
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

class EditTripModuleTest: XCTestCase {
    
    var presenter: MockEditTripPresenter!
    var interactor: MockEditTripInteractor!
    var router: MockEditTripRouter!
    
    var trip: WBTrip?
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = EditTripPresenter()
        let i = EditTripInteractor()
        let r = EditTripRouter()
        
        var module = AppModules.editTrip.build()
        module.injectMock(presenter: MockEditTripPresenter().spy(on: p))
        module.injectMock(interactor: MockEditTripInteractor().spy(on: i))
        module.injectMock(router: MockEditTripRouter().spy(on: r))
        
        presenter = module.presenter as! MockEditTripPresenter
        interactor = module.interactor as! MockEditTripInteractor
        router = module.router as! MockEditTripRouter
        
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
            mock.configureSubscribers().then {
                self.presenter.updateTripSubject.subscribe(onNext: { trip in
                    self.trip?.name = trip.name
                }).addDisposableTo(self.disposeBag)
                
                self.presenter.addTripSubject.subscribe(onNext: { trip in
                    self.trip = trip
                }).addDisposableTo(self.disposeBag)
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToRouter() {
        presenter.close()
        verify(router).close()
    }
    
    func testPresenterToInteractor() {
        presenter.viewHasLoaded()
        verify(interactor).configureSubscribers()
    
        presenter.addTripSubject.onNext(WBTrip())
        XCTAssertNotNil(self.trip)
        
        let updated = WBTrip()
        updated.name = "A"
        presenter.updateTripSubject.onNext(updated)
        XCTAssertEqual(self.trip?.name, "A")
    }
}


