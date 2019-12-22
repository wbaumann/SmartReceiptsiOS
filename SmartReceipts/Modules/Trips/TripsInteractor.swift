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

let LAST_OPENED_TRIP_KEY = "LastOpenedTripKey"

class TripsInteractor: Interactor {
    
    let bag = DisposeBag()
    
    func configureSubscribers() {
        presenter.tripDeleteSubject.subscribe(onNext: { trip in
            Logger.debug("Delete Trip: \(trip.name!)")
            Database.sharedInstance().delete(trip)
        }).disposed(by: bag)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().createUpdatingAdapterForAllTrips()
    }
    
    func markLastOpened(trip: WBTrip) {
        UserDefaults.standard.set(trip.name, forKey: LAST_OPENED_TRIP_KEY)
    }
    
    var lastOpenedTrip: WBTrip? {
        guard let tripName = UserDefaults.standard.value(forKey: LAST_OPENED_TRIP_KEY) as? String else { return nil }
        return Database.sharedInstance().tripWithName(tripName)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsInteractor {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
