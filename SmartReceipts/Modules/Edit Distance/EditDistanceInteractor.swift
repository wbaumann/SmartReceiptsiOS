//
//  EditDistanceInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

final class EditDistanceInteractor: Interactor {
    func save(distance: Distance, asNewDistance: Bool) {
        if (asNewDistance) {
            AnalyticsManager.sharedManager.record(event: Event.distancePersistNewDistance())
        } else {
            AnalyticsManager.sharedManager.record(event: Event.distancePersistUpdateDistance())
        }
        if Database.sharedInstance().save(distance) {
            presenter.close()
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistanceInteractor {
    var presenter: EditDistancePresenter {
        return _presenter as! EditDistancePresenter
    }
}
