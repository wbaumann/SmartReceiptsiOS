//
//  RefreshTripPriceHandler.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

protocol RefreshTripPriceHandler {
    func refreshPriceForTrip(_ trip: WBTrip, inDatabase database: FMDatabase);
}

extension RefreshTripPriceHandler {
    func refreshPriceForTrip(_ trip: WBTrip, inDatabase database: FMDatabase) {
        Logger.debug("Refresh price on \(trip.name)")
        timeMeasured("Price update") {
            //TODO jaanus: maybe lighter query - only price/currency/exchangeRate?
            let receipts = database.fetchUnmarkedForDeletionReceiptsForTrip(trip)
            let distances: [Distance]
            if WBPreferences.isTheDistancePriceBeIncludedInReports() {
                //lighter query also here?
                distances = database.fetchAllDistancesForTrip(trip)
            } else {
                distances = []
            }
            
            let collection = PricesCollection()
            // just so that when no receipts we would not end up with blank price
            collection.addPrice(Price(amount: .zero, currency: trip.defaultCurrency))
            for receipt in receipts {
                collection.addPrice(receipt.targetPrice())
            }
            for distance in distances {
                collection.addPrice(distance.totalRate())
            }
            trip.pricesSummary = collection
        }
    }
}
