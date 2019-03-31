//
//  DatabaseUpgradeToVersion12.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class DatabaseUpgradeToVersion12: DatabaseMigration {
    
    var version: Int {
        return 12
    }
    
    func migrate(_ database: Database) -> Bool {
        AnalyticsManager.sharedManager.record(event: Event.startDatabaseUpgrade(version))
        
        let alterTrips = ["ALTER TABLE ", TripsTable.Name, " ADD ", TripsTable.Column.Filters, " TEXT"]
        let alterReceipts = ["ALTER TABLE ", ReceiptsTable.Name, " ADD ", ReceiptsTable.Column.PaymentMethodId, " INTEGER REFERENCES ", PaymentMethodsTable.Name, " ON DELETE NO ACTION" ]
        
        let result = database.createPaymentMethodsTable()
            && database.executeUpdate(withStatementComponents: alterTrips)
            && database.executeUpdate(withStatementComponents: alterReceipts)
        
        AnalyticsManager.sharedManager.record(event: Event.finishDatabaseUpgrade(version, success: result))
        
        return result
    }
    
}
