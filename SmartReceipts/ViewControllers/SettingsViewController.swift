//
//  SettingsViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension SettingsViewController {
    
    // MARK: - UIDocumentInteractionController
    
    func shareBackupFile(_ path: String, fromRect: CGRect) {
        var showRect = fromRect
        showRect.origin.y += view.frame.origin.y - fromRect.height
        
        let fileUrl = URL(fileURLWithPath: path)
        Logger.info("shareBackupFile via UIDocumentInteractionController with url: \(fileUrl)")
        let controller = UIDocumentInteractionController(url: fileUrl)
        Logger.info("UIDocumentInteractionController UTI: \(controller.uti)")
        controller.presentOptionsMenu(from: showRect, in: view, animated: true)
        documentInteractionController = controller
    }
}

extension SettingsViewController {

    // MARK: - Analytics methods:
    
    // MARK: navigation
    
    func analyticsSettingsOverflow() {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SettingsOverflow)
    }
    
    func analyticsBackupOverflow() {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.BackupOverflow)
    }
    
    func analyticsSmartReceiptsPlusOverflow() {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SmartReceiptsPlusOverflow)
    }
    
    // MARK: IAP
    
    func analyticsPurchaseSuccess(productID: String) {
        let anEvent =  Event.Purchases.PurchaseSuccess
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
    
    func analyticsPurchaseFailed(productID: String) {
        let anEvent =  Event.Purchases.PurchaseSuccess
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
    
    func analyticsShowPurchaseIntent() {
        AnalyticsManager.sharedManager.record(event: Event.Purchases.ShowPurchaseIntent)
    }
    
}
