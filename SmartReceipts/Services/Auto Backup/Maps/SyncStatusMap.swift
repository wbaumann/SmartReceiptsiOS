//
//  SyncStatusMap.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class SyncStatusMap {
    private var syncStatusMap = [SyncProvider : Bool]()
    
    init(map: [SyncProvider : Bool] = [:]) {
        self.syncStatusMap = map
    }
    
    func isSynced(provider: SyncProvider) -> Bool {
        return syncStatusMap[provider] ?? false
    }
}
