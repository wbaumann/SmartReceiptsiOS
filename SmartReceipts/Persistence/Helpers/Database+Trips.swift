//
//  Database+Trips.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension Database: RefreshTripPriceHandler {
    func createUpdatingAdapterForAllTrips() -> FetchedModelAdapter {
        let query = DatabaseQueryBuilder.selectAllStatement(forTable: TripsTable.Name)
        query?.order(by: TripsTable.Column.To, ascending: false)
        
        let adapter = FetchedModelAdapter(database: self)
        adapter.setQuery((query?.buildStatement())!, parameters: (query?.parameters())!)
        adapter.modelClass = WBTrip.self
        adapter.afterFetchHandler = {
            model, database in
            
            guard let trip = model as? WBTrip else {
                return
            }
            
            self.refreshPriceForTrip(trip, inDatabase: database)
        }
        
        adapter.fetch()
        
        return adapter
    }
    
    func tripWithName(_ name: String) -> WBTrip? {
        var trip: WBTrip?
        inDatabase() {
            database in
            
            trip = database.tripWithName(name)
        }
        
        return trip
    }
    
    func refreshPriceForTrip(_ trip: WBTrip) {
        inDatabase { (db) in
            self.refreshPriceForTrip(trip, inDatabase: db)
        }
    }
}
