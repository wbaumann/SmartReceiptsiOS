//
//  SyncableTableCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SyncableTableCell: UITableViewCell {
    @IBOutlet private weak var syncButton: UIButton!
    private var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func setState(_ state: ModelSyncState) {
        syncButton.setImage(state.image(), for: .normal)
        syncButton.isUserInteractionEnabled = state == .disabled
        syncButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.openSyncStateDialog()
        }).disposed(by: bag)
    }
    
    private func openSyncStateDialog() {
        let root = UIApplication.shared.keyWindow!.rootViewController
        let alert = UIAlertController(title: nil, message: LocalizedString("automatic_backups_info_dialog_message"), preferredStyle: .alert)
        alert.addAction(.init(title: LocalizedString("automatic_backups_info_dialog_positive"), style: .default, handler: { _ in
            let backupModuleView = AppModules.backup.build().view
            let navController = UINavigationController(rootViewController: backupModuleView.viewController)
            navController.modalTransitionStyle = .coverVertical
            navController.modalPresentationStyle = .formSheet
            root?.present(navController, animated: true, completion: nil)
        }))
        alert.addAction(.init(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: nil))
        
        root?.present(alert, animated: true, completion: nil)
    }
}


enum ModelSyncState {
    case synced
    case notSynced
    case disabled
    
    func image() -> UIImage {
        switch self {
        case .synced:
            return #imageLiteral(resourceName: "cloud-check")
        case .notSynced:
            return #imageLiteral(resourceName: "cloud")
        case .disabled:
            return #imageLiteral(resourceName: "cloud-off")
        }
    }
    
    static func modelState(modelChangeDate: Date) -> ModelSyncState {
        let remoteSyncDate = BackupProviderFactory().makeBackupProvider(syncProvider: .last).lastDatabaseSyncTime
        var state = ModelSyncState.notSynced
        if remoteSyncDate >= modelChangeDate{
            state = .synced
        } else {
            state = SyncProvider.current == .none ? .disabled : .notSynced
        }
        return state
    }
}
