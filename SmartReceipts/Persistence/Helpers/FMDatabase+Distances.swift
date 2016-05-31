//
//  FMDatabase+Distances.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension FMDatabase {
    func fetchAllDistancesForTrip(trip: WBTrip) -> [Distance] {
        let query = DatabaseQueryBuilder()
        return fetch(Distance.self, query: query)
    }
}