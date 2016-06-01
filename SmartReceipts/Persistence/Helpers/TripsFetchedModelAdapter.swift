//
//  TripsFetchedModelAdapter.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class TripsFetchedModelAdapter: FetchedModelAdapter {
    func refreshPriceForTrip(trip: WBTrip, inDatabase database: FMDatabase) {
        Log.debug("Refresh price on \(trip.name)")
        timeMeasured("Price update") {
            //TODO jaanus: maybe lighter query - only price/currency/exchangeRate?
            let receipts = database.fetchAllReceiptsForTrip(trip)
            let distances: [Distance]
            if WBPreferences.isTheDistancePriceBeIncludedInReports() {
                //lighter query also here?
                distances = database.fetchAllDistancesForTrip(trip)
            } else {
                distances = []
            }
            
            let collection = PricesCollection()
            for receipt in receipts {
                collection.addPrice(receipt.targetPrice())
            }
            trip.price = collection
        }
    }
}