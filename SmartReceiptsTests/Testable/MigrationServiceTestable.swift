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
    var migratedIlligalTripNames = false
    
    override func migrateIlligalTripNames() {
        migratedIlligalTripNames = true
    }
}
