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
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        var module = AppModules.editTrip.build()
        module.injectMock(presenter: MockEditTripPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockEditTripInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockEditTripRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! MockEditTripPresenter
        interactor = module.interactor as! MockEditTripInteractor
        router = module.router as! MockEditTripRouter
        
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
                }).disposed(by: self.bag)
                
                self.presenter.addTripSubject.subscribe(onNext: { trip in
                    self.trip = trip
                }).disposed(by: self.bag)
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


