//
//  EditDistanceInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class EditDistanceInteractor: Interactor {
    
    private let disposeBag = DisposeBag()
    private var database: Database!
    
    required init() {
        database = Database.sharedInstance()
    }
    
    init(database: Database) {
        self.database = database
    }

    
    func save(distance: Distance, asNewDistance: Bool) {
        if (asNewDistance) {
            AnalyticsManager.sharedManager.record(event: Event.distancePersistNewDistance())
        } else {
            AnalyticsManager.sharedManager.record(event: Event.distancePersistUpdateDistance())
        }
        
        if database.save(distance) {
            Logger.debug("Distance has been \(asNewDistance ? "updated" : "added")")
            validateDate(in: distance)
            presenter.close()
        } else {
            Logger.error("Distance can't be \(asNewDistance ? "updated" : "added")")
        }
    }
    
    private func validateDate(in distance: Distance) {
        Observable<Void>.just()
            .filter({distance.date > distance.trip.endDate || distance.date < distance.trip.startDate})
            .subscribe(onNext: {
                let message = LocalizedString("edit.distance.date.range.warning.message")
                Toast.show(message)
            }).disposed(by: disposeBag)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistanceInteractor {
    var presenter: EditDistancePresenter {
        return _presenter as! EditDistancePresenter
    }
}
