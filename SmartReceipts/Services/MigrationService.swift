//
//  MigrationService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

fileprivate let migrationKey = "migration_version_key"

class MigrationService {
    
    // MARK: - Public Interface
    
    func migrate() {
        
        //MARK: Migration 0 -> 1
        migrate(from: 0, to: 1, {
            migrateIlligalTripNames()
        })
        
    }
    
    private func migrate(from: Int, to: Int, _ migrationBlock: MigrationBlock) {
        let currentVersion = UserDefaults.standard.integer(forKey: migrationKey)
        if from == currentVersion && to == MIGRATION_VERSION {
            migrationBlock()
        }
    }
    
    // MARK: - Private Interface
    
    func migrateIlligalTripNames() {
        for trip in Database.sharedInstance().allTrips() as! [WBTrip] {
            trip.name = WBTextUtils.omitIllegalCharacters(trip.name)
            Database.sharedInstance().update(trip)
        }
    }
    
}
