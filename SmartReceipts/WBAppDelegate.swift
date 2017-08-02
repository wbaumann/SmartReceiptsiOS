//
//  WBAppDelegate.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RMStore

extension WBAppDelegate {
    
    func enableAnalytics() {
        AnalyticsManager.sharedManager.register(newService: GoogleAnalytics())
        AnalyticsManager.sharedManager.register(newService: FirebaseAnalytics())
        AnalyticsManager.sharedManager.register(newService: AnalyticsLogger())
    }
    
    func logPurchases() {
        guard let receipt = RMAppReceipt.bundle() else { return }
        Logger.debug("=== Purchases info ===")
        Logger.debug("Receipt: \(receipt.description)")
        Logger.debug("\(receipt.inAppPurchases.count) IAP-s")
        if let iaps = receipt.inAppPurchases as? [RMAppReceiptIAP] {
            for iap in iaps {
                Logger.debug("IAP receipt: \(iap.description)")
                Logger.debug("Purchase: \(iap.purchaseDate)")
                Logger.debug("Original purchase: \(iap.originalPurchaseDate)")
                Logger.debug("Expire: \(iap.subscriptionExpirationDate)")
            }
        }
        Logger.debug("======================")
    }
}
