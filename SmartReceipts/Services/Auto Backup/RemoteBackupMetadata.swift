//
//  RemoteBackupMetadata.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

protocol RemoteBackupMetadata {
    var id: String { get }
    var syncDeviceId: String { get }
    var syncDeviceName: String { get }
    var lastModifiedDate: Date { get }
}
