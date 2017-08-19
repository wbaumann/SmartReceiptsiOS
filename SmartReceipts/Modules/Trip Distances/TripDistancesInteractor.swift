//
//  TripDistancesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class TripDistancesInteractor: Interactor {
    private var database: Database!
    var trip: WBTrip!
    
    required init() {
        database = Database.sharedInstance()
    }
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        return database.fetchedAdapterForDistances(in: trip)
    }
    
    func totalDistancePrice() -> String {
        let priceCollection = PricesCollection()
        priceCollection.addPrice(Price(currencyCode: WBPreferences.defaultCurrency()))
        
        let distances = Database.sharedInstance().fetchedAdapterForDistances(in: trip, ascending: true)
        let distanceReceipts = DistancesToReceiptsConverter.convertDistances(distances!.allObjects()) as! [WBReceipt]
        
        for receipt in distanceReceipts {
            if Calendar.current.isDateInToday(receipt.date) {
                let price = receipt.exchangedPrice() ?? receipt.price()
                priceCollection.addPrice(price)
            }
        }
        return String(format: LocalizedString("trips.controller.distance.total"), priceCollection.currencyFormattedPrice())
    }
    
    func delete(distance: Distance) {
        if database.delete(distance) {
            Logger.debug("Distance deleted")
        } else {
            Logger.error("Distance can't be deleted")
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesInteractor {
    var presenter: TripDistancesPresenter {
        return _presenter as! TripDistancesPresenter
    }
}
