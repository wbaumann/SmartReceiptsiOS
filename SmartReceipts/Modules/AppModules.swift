//
//  AppModules.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

enum AppModules: String, ViperitModule {
    case auth
    case tripDistances
    case editDistance
    case generateReport
    case trips
    case editTrip
    case receipts
    case editReceipt
    case receiptMoveCopy
    case receiptImageViewer
    case settings
    case columns
    case paymentMethods
    case categories
    case debug
    case OCRConfiguration
    case backup
}
