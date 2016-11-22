//
//  FMDatabase+Distances.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

extension FMDatabase {
    func fetchAllDistancesForTrip(_ trip: WBTrip) -> [Distance] {
        if let query = DatabaseQueryBuilder.selectAllStatement(forTable: DistanceTable.Name) {
            query.`where`(DistanceTable.Column.Parent, value: trip.name as NSObject!)
            return fetch(query)
        } else {
            return []
        }
    }
}
