//
//  TripsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class TripsPresenter: Presenter {
    
    let tripDetailsSubject = PublishSubject<WBTrip>()
    let tripEditSubject = PublishSubject<WBTrip>()
    let tripDeleteSubject = PublishSubject<WBTrip>()
    
    private let disposeBag = DisposeBag()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        executeFor(iPhone: {}, iPad: { router.openNoTrips() })
        
        view.addButton.rx.tap.subscribe(onNext: {
            self.router.openAddTrip()
        }).disposed(by: disposeBag)
        
        view.settingsButton.rx.tap.subscribe(onNext: {
            self.router.openSettings()
        }).disposed(by: disposeBag)
        
        view.debugButton.rx.tap.subscribe(onNext: {
            self.router.openDebug()
        }).disposed(by: disposeBag)
        
        tripDetailsSubject.subscribe(onNext: { trip in
            self.router.openDetails(trip: trip)
        }).disposed(by: disposeBag)
        
        tripEditSubject.subscribe(onNext: { trip in
            self.router.openEdit(trip: trip)
        }).disposed(by: disposeBag)
        
    }
    
    func presentSettings() {
        router.openSettings()
    }
    
    func presentAddTrip() {
        router.openAddTrip()
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return interactor.fetchedModelAdapter()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsPresenter {
    var view: TripsViewInterface {
        return _view as! TripsViewInterface
    }
    var interactor: TripsInteractor {
        return _interactor as! TripsInteractor
    }
    var router: TripsRouter {
        return _router as! TripsRouter
    }
}
