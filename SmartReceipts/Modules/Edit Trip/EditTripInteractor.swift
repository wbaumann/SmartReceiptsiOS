//
//  EditTripInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class EditTripInteractor: Interactor {
    
    private let bag = DisposeBag()
    
    func configureSubscribers() {
        presenter.updateTripSubject.subscribe(onNext: { [weak self] trip in
            Logger.debug("Update Trip: \(trip.name)")
            self?.save(trip: trip, update: true)
        }).disposed(by: bag)
        
        presenter.addTripSubject.subscribe(onNext: { [weak self] trip in
            Logger.debug("Add Trip: \(trip.name)")
            self?.save(trip: trip)
        }).disposed(by: bag)
    }
    
    func save(trip: WBTrip, update: Bool = false) {
        trip.name = WBTextUtils.omitIllegalCharacters(trip.name)
        let success = update ? Database.sharedInstance().update(trip) : Database.sharedInstance().save(trip)
        if success {
            presenter.close()
        } else {
            let action = update ? "update" : "insert"
            Logger.error("Can't \(action) report: \(trip.description)")
            presenter.presentAlert(title: LocalizedString("generic.error.alert.title"),
                                 message: LocalizedString("toast_error_trip_exists"))
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditTripInteractor {
    var presenter: EditTripPresenter {
        return _presenter as! EditTripPresenter
    }
}
