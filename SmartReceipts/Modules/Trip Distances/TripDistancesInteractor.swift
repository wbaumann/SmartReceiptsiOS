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
    private var database: Database!
    
    required init() {
        database = Database.sharedInstance()
    }
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        return database.fetchedAdapterForDistances(in: trip)
    }
    
    func delete(distance: Distance) {
        if database.delete(distance) {
            Logger.debug("Distance deleted")
        } else {
            Logger.debug("Distance can't be deleted")
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesInteractor {
    var presenter: TripDistancesPresenter {
        return _presenter as! TripDistancesPresenter
    }
}
