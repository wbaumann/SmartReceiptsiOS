//
//  DatabaseUpgradeToVersion13.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class DatabaseUpgradeToVersion13: DatabaseMigration {
    
    var version: Int {
        return 13
    }
    
    func migrate(_ database: Database) -> Bool {
        AnalyticsManager.sharedManager.record(event: Event.startDatabaseUpgrade(version))
        
        let parent = "parent"
        let distanceMigrateBase = ["INSERT INTO ", DistanceTable.Name,
            "(", parent, ", ", DistanceTable.Column.Distance, ", ", DistanceTable.Column.Location, ", ",
            DistanceTable.Column.Date, ", ", DistanceTable.Column.Timezone, ", ", DistanceTable.Column.Comment,
            ", ", DistanceTable.Column.RateCurrency, ")", " SELECT ", TripsTable.Column.Name, ", ",
            TripsTable.Column.Mileage, " , \"\" as ", DistanceTable.Column.Location, ", ", TripsTable.Column.From,
            ", ", TripsTable.Column.FromTimezone, " , \"\" as ", DistanceTable.Column.Comment, ", "
        ]
        
        let distanceMigrateNotNullCurrency = distanceMigrateBase + [
            TripsTable.Column.DefaultCurrency, " FROM ", TripsTable.Name, " WHERE ", TripsTable.Column.DefaultCurrency,
            " IS NOT NULL AND ", TripsTable.Column.Mileage, " > 0;"
        ]
        
        let distanceMigrateNullCurrency = distanceMigrateBase + [
            "\"", WBPreferences.defaultCurrency(), "\" as ", DistanceTable.Column.RateCurrency,
            " FROM ", TripsTable.Name, " WHERE ", TripsTable.Column.DefaultCurrency,
            " IS NULL AND ", TripsTable.Column.Mileage, " > 0;"
        ]
        
        let alterTripsWithCostCenter = ["ALTER TABLE ", TripsTable.Name, " ADD ", TripsTable.Column.CostCenter, " TEXT"]
        let alterTripsWithProcessingStatus = ["ALTER TABLE ", TripsTable.Name, " ADD ", TripsTable.Column.ProcessingStatus, " TEXT"]
        let alterReceiptsWithProcessingStatus = ["ALTER TABLE ", ReceiptsTable.Name, " ADD ", ReceiptsTable.Column.ProcessingStatus, " TEXT"]
        
        let result = database.createDistanceTable() && database.executeUpdate(withStatementComponents: distanceMigrateNotNullCurrency) && database.executeUpdate(withStatementComponents: distanceMigrateNullCurrency) && database.executeUpdate(withStatementComponents: alterTripsWithCostCenter) && database.executeUpdate(withStatementComponents: alterTripsWithProcessingStatus) && database.executeUpdate(withStatementComponents: alterReceiptsWithProcessingStatus)
        
        AnalyticsManager.sharedManager.record(event: Event.finishDatabaseUpgrade(version, success: result))
        
        return result
        
        
    }
    
}
