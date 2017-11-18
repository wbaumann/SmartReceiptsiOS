//
//  AppDelegate.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RMStore
import Firebase
import UIAlertView_Blocks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    fileprivate(set) var filePathToAttach: String?
    fileprivate(set) var isFileImage: Bool = false
    static private(set) var instance: AppDelegate!
    let dataQueue = DispatchQueue(label: "wb.dataAccess")
    
    private var receiptVerification = RMStoreAppReceiptVerificator()
    private var keychainPersistence = RMStoreKeychainPersistence()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        AppDelegate.instance = self
        FirebaseApp.configure()
        enableAnalytics()
        AppTheme.customizeOnAppLoad()
    
        RMStore.default().receiptVerificator = receiptVerification
        RMStore.default().transactionPersistor = keychainPersistence
        
        _ = FileManager.initTripsDirectory()
        Database.sharedInstance().open()
        Database.sharedInstance().checkReceiptValidity()
    
        RecentCurrenciesCache.shared.update()
        
        Logger.info("Language: \(Locale.preferredLanguages.first!)")
        
        NSSetUncaughtExceptionHandler { exception in
            RateApplication.sharedInstance().markAppCrash()
            
            var message = exception.description
            message += "\n"
            message += exception.callStackSymbols.description
            Logger.error(message, file: "UncaughtExcepetion", function: "onUncaughtExcepetion", line: 0)
            FirebaseCrashMessage(message)
            
            let errorEvent = ErrorEvent(exception: exception)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        }
        
        RateApplication.sharedInstance().markAppLaunch()
        logPurchases()
        PushNotificationService.shared.initialize()
        ScansPurchaseTracker.shared.initialize()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        freeFilePathToAttach()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Database.sharedInstance().close()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.isFileURL {
            if url.pathExtension.isStringIgnoreCaseIn(array: ["png", "jpg", "jpeg"]) {
                Logger.info("Launched for image")
                isFileImage = true
                handlePDForImage(url: url)
            } else if url.pathExtension.caseInsensitiveCompare("pdf") == .orderedSame {
                Logger.info("Launched for pdf")
                isFileImage = false
                handlePDForImage(url: url)
            } else if url.pathExtension.caseInsensitiveCompare("smr") == .orderedSame {
                Logger.info("Launched for smr")
                handleSMR(url: url)
            } else {
                Logger.info("Loaded with unknown file")
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate {
    func freeFilePathToAttach() {
        guard let path = filePathToAttach else { return }
        FileManager.deleteIfExists(filepath: path)
        filePathToAttach = nil
    }
}

// MARK: Help Methods
fileprivate extension AppDelegate {
    func handlePDForImage(url: URL) {
        var path = url.path
        path = path.hasSuffix("/") ? path.substring(to: String.Index(path.count-1)) : path
        filePathToAttach = path
        
        if isFileImage {
            UIAlertView(title: LocalizedString("app.delegate.attach.image.alert.title"),
                        message: LocalizedString("app.delegate.attach.image.alert.message"),
                        delegate: nil,
                        cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
        } else {
            UIAlertView(title: LocalizedString("app.delegate.attach.pdf.alert.title"),
                        message: LocalizedString("app.delegate.attach.pdf.alert.message"),
                        delegate: nil,
                        cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
        }
    }
    
    func handleSMR(url: URL) {
        let alert = UIAlertController(title: LocalizedString("app.delegate.import.alert.title"),
          message: LocalizedString("app.delegate.import.alert.message"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: { _ in
            FileManager.deleteIfExists(filepath: url.path)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.yes"), style: .default, handler: { _ in
            self.importZip(from: url, overwrite: true)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.no"), style: .default, handler: { _ in
            self.importZip(from: url, overwrite: false)
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func importZip(from: URL, overwrite: Bool) {
        let hud = PendingHUDView.show(on: window!.rootViewController!.view)
        dataQueue.async {
            let dataImport = DataImport(inputFile: from.path, output: FileManager.documentsPath)
            var success = true
            
            if success {
                // delete imported zip and import data to DB
                FileManager.deleteIfExists(filepath: from.path)
                let backupPath = FileManager.pathInDocuments(relativePath: SmartReceiptsDatabaseExportName)
                success = Database.sharedInstance().importData(fromBackup: backupPath, overwrite: overwrite)
            }
            
            DispatchQueue.main.async {
                hud.hide()
                if success {
                    UIAlertView(title: nil, message: LocalizedString("app.delegate.import.success.alert.message"),
                                delegate: nil,
                                cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
                    Logger.error("app.delegate.import.success")
                } else {
                    UIAlertView(title: LocalizedString("generic.error.alert.title"),
                                message: LocalizedString("app.delegate.import.error.alert.message"),
                                delegate: nil,
                                cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
                    Logger.error("app.delegate.import.error")
                }
            }
            dataImport.execute()
            NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsImport, object: nil)
        }
    }
}

extension AppDelegate {
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
