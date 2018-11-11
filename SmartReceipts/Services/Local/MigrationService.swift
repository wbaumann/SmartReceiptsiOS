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
        migrate(to: 1, {
            migrateIlligalTripNames()
        })
        
        migrate(to: 2, {
            migrateCustomOrderIds()
        })
        
        // Commit Migration Version
        UserDefaults.standard.set(MIGRATION_VERSION, forKey: migrationKey)
    }
    
    private func migrate(to: Int, _ migrationBlock: MigrationBlock) {
        let currentVersion = UserDefaults.standard.integer(forKey: migrationKey)
        if currentVersion < MIGRATION_VERSION && currentVersion < to {
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
    
    func migrateCustomOrderIds() {
        for trip in Database.sharedInstance().allTrips() as! [WBTrip] {
            let receipts = Array(Database.sharedInstance().allReceipts(for: trip).reversed()) as! [WBReceipt]
            for receipt in receipts {
                let idGroup = (receipt.date as NSDate).days()
                let receiptsCount = Database.sharedInstance().receiptsCount(inOrderIdGroup: idGroup)
                let newOrderId = idGroup * kDaysToOrderFactor + receiptsCount + 1
                receipt.customOrderId = newOrderId
                Database.sharedInstance().save(receipt)
            }
        }
    }
    
}
