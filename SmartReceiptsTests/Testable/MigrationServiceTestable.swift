//
//  MigrationServiceTestable.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 09/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import Foundation

class MigrationServiceTestable: MigrationService {
    var migrateIlligalTripNamesCalls = 0
    var migrateCustomOrderIdsCalls = 0
    
    override func migrateIlligalTripNames() {
        migrateIlligalTripNamesCalls += 1
    }
    
    override func migrateCustomOrderIds() {
        migrateCustomOrderIdsCalls += 1
    }
}
