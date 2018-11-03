//
//  AppDelegate.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import Firebase
import RxSwift
import Crashlytics
import SwiftyStoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static private(set) var instance: AppDelegate!
    
    private let purchaseService = PurchaseService()
    
    fileprivate(set) var filePathToAttach: String?
    fileprivate(set) var isFileImage: Bool = false
    fileprivate var dataImport: DataImport!
    
    var window: UIWindow?
    
    let dataQueue = DispatchQueue(label: "wb.dataAccess")
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        AppDelegate.instance = self
        AppMonitorServiceFactory().createAppMonitor().configure()
        
        AppTheme.customizeOnAppLoad()
        Crashlytics.sharedInstance().debugMode = DebugStates.isDebug
        
        _ = FileManager.initTripsDirectory()
        
        if !Database.sharedInstance().open() {
            NSException(name: NSExceptionName(rawValue: "DBOpenFail"), reason: nil, userInfo: [:]).raise()
        }
        
        RecentCurrenciesCache.shared.update()
        
        Logger.info("Language: \(Locale.preferredLanguages.first!)")
        
        setupCustomExceptionHandler()
        
        purchaseService.cacheSubscriptionValidation()
        purchaseService.logPurchases()
        purchaseService.completeTransactions()
        
        RateApplication.sharedInstance().markAppLaunch()
        PushNotificationService.shared.initialize()
        ScansPurchaseTracker.shared.initialize()
        GoogleDriveService.shared.initialize()
        SyncService.shared.initialize()
        
        MigrationService().migrate()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        freeFilePathToAttach()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Database.sharedInstance().close()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        _ = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }
        
        if url.isFileURL {
            let tempURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(url.lastPathComponent)!
            do { try FileManager.default.copyItem(at: url, to: tempURL) }
            catch { Logger.error("Can't copy temp file \(tempURL.lastPathComponent)") }
            
            if url.pathExtension.isStringIgnoreCaseIn(array: ["png", "jpg", "jpeg"]) {
                Logger.info("Launched for image")
                if DataValidator().isValidImage(url: tempURL) {
                    isFileImage = true
                    handlePDForImage(url: tempURL)
                } else {
                    Logger.error("Invalid Image for import")
                }
            } else if url.pathExtension.caseInsensitiveCompare("pdf") == .orderedSame {
                Logger.info("Launched for pdf")
                if DataValidator().isValidPDF(url: tempURL) {
                    isFileImage = false
                    handlePDForImage(url: tempURL)
                } else {
                    Logger.error("Invalid PDF for import")
                }
            } else if url.pathExtension.caseInsensitiveCompare("smr") == .orderedSame {
                Logger.info("Launched for smr")
                handleSMR(url: tempURL)
            } else {
                Logger.info("Loaded with unknown file")
            }
        } else {
            let sourceApp = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
            let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: annotation)
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
extension AppDelegate {
    func handlePDForImage(url: URL) {
        var path = url.path
        
        path = path.hasSuffix("/") ? String(path[..<path.index(before: path.endIndex)]) : path
        filePathToAttach = path
        
        if isFileImage {
            // String(format: LocalizedString("dialog_attachment_text"), LocalizedString("image"))
            let alert = UIAlertController(title: LocalizedString("receipt_attach_file"),
                message: String(format: LocalizedString("dialog_attachment_text"), LocalizedString("image")), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.ok"), style: .cancel, handler: nil))
            AdNavigationEntryPoint.navigationController?.visibleViewController?.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: LocalizedString("receipt_attach_file"),
                message: String(format: LocalizedString("dialog_attachment_text"), LocalizedString("pdf")), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.ok"), style: .cancel, handler: nil))
            AdNavigationEntryPoint.navigationController?.visibleViewController?.present(alert, animated: true)
        }
    }
    
    func handleSMR(url: URL) {
        let alert = UIAlertController(title: LocalizedString("manual_backup_import"),
          message: LocalizedString("dialog_import_text"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: { _ in
            FileManager.deleteIfExists(filepath: url.path)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizedString("yes"), style: .default, handler: { _ in
            self.importZip(from: url, overwrite: true)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizedString("no"), style: .default, handler: { _ in
            self.importZip(from: url, overwrite: false)
        }))
        AdNavigationEntryPoint.navigationController?.visibleViewController?.present(alert, animated: true)
    }
    
    func importZip(from: URL, overwrite: Bool) {
        guard let viewController = AdNavigationEntryPoint.navigationController?.visibleViewController else { return }
        let hud = PendingHUDView.show(on: viewController.view)
        dataQueue.async {
            self.dataImport = DataImport(inputFile: from.path, output: FileManager.documentsPath)
            _ = self.dataImport.execute(overwrite: overwrite)
                .subscribeOn(MainScheduler.instance)
                .subscribe(onNext: {
                    SyncService.shared.trySyncData()
                    hud.hide()
                    NotificationCenter.default.post(name: .SmartReceiptsImport, object: nil)
                    let text = LocalizedString("toast_import_complete")
                    _ = UIAlertController.showInfo(text: text, on: viewController).subscribe()
                    Logger.debug("Successfully imported all reciepts")
                }, onError: { error in
                    hud.hide()
                    let text = LocalizedString("IMPORT_ERROR")
                    _ = UIAlertController.showInfo(text: text, on: viewController).subscribe()
                    Logger.error("Failed to import this backup: \(error.localizedDescription)")
                })
        }
    }
    
    fileprivate func setupCustomExceptionHandler() {
        // Catches most but not all fatal errors
        NSSetUncaughtExceptionHandler { exception in
            RateApplication.sharedInstance().markAppCrash()
            
            var message = exception.description
            message += "\n"
            message += exception.callStackSymbols.description
            Logger.error(message, file: "UncaughtExcepetion", function: "onUncaughtExcepetion", line: 0)
            Crashlytics.sharedInstance().recordCustomExceptionName(exception.name.rawValue, reason: exception.reason, frameArray: [])
            
            let errorEvent = ErrorEvent(exception: exception)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        }
    }
}
