//
//  FMDatabase+Trips.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension FMDatabase: RefreshTripPriceHandler {
    func tripWithName(name: String) -> WBTrip? {
        let select = DatabaseQueryBuilder.selectAllStatementForTable(TripsTable.Name)
        select.`where`(TripsTable.Column.Name, value: name)
        return fetchSingle(select) {
            trip in
            
            self.refreshPriceForTrip(trip, inDatabase: self)
        }
    }
}