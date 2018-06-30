//
//  BackupProviderFactory.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class BackupProviderFactory {
    func makeBackupProvider(syncProvider: SyncProvider) -> BackupProvider {
        switch syncProvider {
        case .googleDrive:
            return GoogleDriveBackupProvider()
        default:
            return NoOpBackupProvider()
        }
    }
}
