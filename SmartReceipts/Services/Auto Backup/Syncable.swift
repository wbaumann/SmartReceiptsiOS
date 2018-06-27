//
//  Syncable.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

protocol Syncable {
    var syncState: SyncState { get }
}

