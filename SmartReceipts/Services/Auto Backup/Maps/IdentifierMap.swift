//
//  IdentifierMap.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class IdentifierMap {
    private var identifierMap = [SyncProvider : String]()
    
    init(map: [SyncProvider : String] = [:]) {
        self.identifierMap = map
    }
    
    func syncId(provider: SyncProvider) -> String? {
        return identifierMap[provider]
    }
}
