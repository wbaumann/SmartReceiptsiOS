//
//  MarkedForDeletionMap.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class MarkedForDeletionMap {
    private var markedForDeletionMap = [SyncProvider : Bool]()
    
    init(map: [SyncProvider : Bool] = [:]) {
        self.markedForDeletionMap = map
    }
    
    func isMarkedForDeletion(provider: SyncProvider) -> Bool {
        return markedForDeletionMap[provider] ?? false
    }
}
