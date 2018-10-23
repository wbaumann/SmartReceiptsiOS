//
//  FMDatabase+Trips.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

extension FMDatabase: RefreshTripPriceHandler {
    func tripWithName(_ name: String) -> WBTrip? {
        if let select = DatabaseQueryBuilder.selectAllStatement(forTable: TripsTable.Name) {
            select.where(TripsTable.Column.Name, value: name.asNSString)
            return fetchSingle(select) { trip in
                self.refreshPriceForTrip(trip, inDatabase: self)
            }
        } else {
            return nil
        }
    }
    
    func tripBy(id: Int) -> WBTrip? {
        if let select = DatabaseQueryBuilder.selectAllStatement(forTable: TripsTable.Name) {
            select.where(TripsTable.Column.Id, value: NSNumber(value: id))
            return fetchSingle(select) { trip in
                self.refreshPriceForTrip(trip, inDatabase: self)
            }
        } else {
            return nil
        }
    }
}
