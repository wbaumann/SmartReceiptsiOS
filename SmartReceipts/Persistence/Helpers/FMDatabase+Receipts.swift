//
//  FMDatabase+Receipts.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension FMDatabase {    
    func fetchAllReceiptsForTrip(trip: WBTrip) -> [WBReceipt] {
        let query = WBReceipt.selectAllQueryForTrip(trip)

        let injectTripClosure: (WBReceipt) -> () = {
            receipt in
            
            receipt.trip = trip
        }
        
        return fetch(query, inject: injectTripClosure)
    }
}