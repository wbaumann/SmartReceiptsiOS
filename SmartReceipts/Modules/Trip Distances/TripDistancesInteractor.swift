//
//  TripDistancesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

final class TripDistancesInteractor: Interactor {
    
    func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        return Database.sharedInstance().fetchedAdapterForDistances(in: trip)
    }
    
    func delete(distance: Distance) {
        Database.sharedInstance().delete(distance)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesInteractor {
    var presenter: TripDistancesPresenter {
        return _presenter as! TripDistancesPresenter
    }
}
