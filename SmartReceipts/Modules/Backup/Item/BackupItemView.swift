//
//  BackupItemView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

class BackupItemView: UIView {
    @IBOutlet private weak var deviceName: UILabel!
    @IBOutlet private weak var serviceName: UILabel!
    @IBOutlet private weak var syncDate: UILabel!
    
    func setup(backup: RemoteBackupMetadata) {
        deviceName.text = backup.syncDeviceName
        serviceName.text = SyncProvider.current.localizedTitle()
        syncDate.text = WBDateFormatter().formattedDate(backup.lastModifiedDate, in: .current)
    }

}
