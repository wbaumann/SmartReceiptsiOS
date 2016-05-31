//
//  Database+Trips.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension Database {
    func createUpdatingAdapterForAllTrips() -> TripsFetchedModelAdapter {
        let query = DatabaseQueryBuilder.selectAllStatementForTable(TripsTable.Name)
        query.orderBy(TripsTable.Column.To, ascending: false)
        
        let adapter = TripsFetchedModelAdapter(database: self)
        adapter.setQuery(query.buildStatement(), parameters: query.parameters())
        adapter.modelClass = WBTrip.self
        adapter.afterFetchHandler = {
            [weak adapter] model, database in
            
            guard let trip = model as? WBTrip, adapter = adapter else {
                return
            }
            
            adapter.refreshPriceForTrip(trip, inDatabase: database)
        }
        
        adapter.fetch()
        
        return adapter
    }
}