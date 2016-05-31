//
//  TripsFetchedModelAdapter.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class TripsFetchedModelAdapter: FetchedModelAdapter {
    func refreshPriceForTrip(trip: WBTrip) {
        Log.debug("Refresh price on \(trip.name)")
        timeMeasured("Price update") {
            
        }
    }
}