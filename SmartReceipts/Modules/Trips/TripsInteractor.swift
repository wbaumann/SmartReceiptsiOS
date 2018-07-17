//
//  TripsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

fileprivate let LAST_OPENED_TRIP_KEY = "LastOpenedTripKey"

class TripsInteractor: Interactor {
    
    let bag = DisposeBag()
    
    func configureSubscribers() {
        presenter.tripDeleteSubject.subscribe(onNext: { trip in
            Logger.debug("Delete Trip: \(trip.name)")
            if Database.sharedInstance().delete(trip) {
                SyncService.shared.syncDatabase()
            }
        }).disposed(by: bag)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().createUpdatingAdapterForAllTrips()
    }
    
    func markLastOpened(trip: WBTrip) {
        UserDefaults.standard.set(trip.name, forKey: LAST_OPENED_TRIP_KEY)
    }
    
    var lastOpenedTrip: Observable<WBTrip> {
        return Maybe<WBTrip>.create(subscribe: { maybe in
            if let tripName = UserDefaults.standard.value(forKey: LAST_OPENED_TRIP_KEY) as? String,
               let trip = Database.sharedInstance().tripWithName(tripName) {
                maybe(.success(trip))
            }
            maybe(.completed)
            return Disposables.create()
        }).asObservable()
        .subscribeOn(OperationQueueScheduler(operationQueue: OperationQueue()))
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsInteractor {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
