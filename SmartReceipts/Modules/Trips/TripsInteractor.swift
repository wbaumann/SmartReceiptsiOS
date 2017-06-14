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

class TripsInteractor: Interactor {
    
    let disposeBag = DisposeBag()
    
    func configureSubscribers() {
        presenter.tripDeleteSubject.subscribe(onNext: { trip in
            Database.sharedInstance().delete(trip)
        }).addDisposableTo(disposeBag)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().createUpdatingAdapterForAllTrips()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsInteractor {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
