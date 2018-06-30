//
//  CriticalSyncError.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

public class CriticalSyncError: Error {
    private(set) var syncErrorType: SyncErrorType
    
    init(syncErrorType: SyncErrorType) {
        self.syncErrorType = syncErrorType
    }
}
