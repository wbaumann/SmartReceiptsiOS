//
//  BackupItemView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class BackupItemView: UIView {
    @IBOutlet private weak var deviceName: UILabel!
    @IBOutlet private weak var serviceName: UILabel!
    @IBOutlet private weak var syncDate: UILabel!
    @IBOutlet private weak var menu: UIButton!
    @IBOutlet private(set) weak var dotsView: UIView!
    
    func setup(backup: RemoteBackupMetadata, isCurrentDevice: Bool =  false) {
        let format = isCurrentDevice ? LocalizedString("existing_remote_backup_current_device") : "%@"
        deviceName.text = String(format: format, backup.syncDeviceName)
        serviceName.text = SyncProvider.current.localizedTitle()
        syncDate.text = WBDateFormatter().formattedDate(backup.lastModifiedDate, in: .current)
        menu.layer.cornerRadius = AppTheme.buttonCornerRadius
    }
    
    func onMenuTap() -> Observable<Void> {
        return menu.rx.tap.asObservable()
    }
    
    // MARK: - Actions
    
    @IBAction private func hightlight() {
        menu.backgroundColor = #colorLiteral(red: 0.2020273507, green: 0.1010685936, blue: 0.5962305665, alpha: 0.09622073763)
    }
    
    @IBAction private func unhightlight() {
        menu.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }

}
