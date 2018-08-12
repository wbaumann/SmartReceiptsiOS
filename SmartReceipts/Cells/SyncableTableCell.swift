//
//  SyncableTableCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

enum ModelSyncState {
    case synced
    case syncing
    case disabled
    
    func image() -> UIImage {
        switch self {
        case .synced:
            return #imageLiteral(resourceName: "cloud-check")
        case .syncing:
            return #imageLiteral(resourceName: "cloud")
        case .disabled:
            return #imageLiteral(resourceName: "cloud-off")
        }
    }
    
    static func modelState(modelChangeDate: Date) -> ModelSyncState {
        if SyncProvider.current == .none {
            return .disabled
        } else {
            let remoteSyncDate = BackupProvidersManager(syncProvider: .current).lastDatabaseSyncTime
            return remoteSyncDate >= modelChangeDate ? .synced : .syncing
        }
        
    }
}

class SyncableTableCell: UITableViewCell {
    @IBOutlet private weak var syncButton: UIButton!
    
    func setState(_ state: ModelSyncState) {
        syncButton.setImage(state.image(), for: .normal)
    }
}

