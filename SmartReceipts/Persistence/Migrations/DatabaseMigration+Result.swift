//
//  DatabaseMigration+Result.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation
import MessageUI

private let FAILED_MIGRATION_COUNT_KEY = "db.migration.failed.count"
private let FAILS_TO_REPORT = 3

extension DatabaseMigrator {
    
    func processFailedMigration(databasePath: String) {
        Logger.error("Dabase Migration Failed!")
        
        let failsCount = UserDefaults.standard.integer(forKey: FAILED_MIGRATION_COUNT_KEY) + 1
        UserDefaults.standard.set(failsCount, forKey: FAILED_MIGRATION_COUNT_KEY)
        
        guard failsCount >= FAILS_TO_REPORT else { exit(0); }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        window.rootViewController = UIViewController()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "launch_image"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        window.rootViewController?.view.addSubview(imageView)
        window.makeKeyAndVisible()
        
        let title = LocalizedString("generic_error_alert_title")
        let message = LocalizedString("migration_failed_alert_message")
        let style: UIAlertController.Style = .alert
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let report = UIAlertAction(title: LocalizedString("migration_failed_alert_send_button"), style: .default, handler: { [weak self] _ in
            let backup = DataExport(workDirectory: FileManager.documentsPath).execute()
            let data = try! Data(contentsOf: backup.asFileURL)
            let attachment = FeedbackAttachment(data: data, mimeType: "application/zip", fileName: SmartReceiptsExportName)
            let subject = "Database Migration Failed - Report"
            self?.feedbackComposer.present(on: window.rootViewController!, subject: subject, attachments: [attachment])
        })
        
        let cancel = UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: nil)
        
        actionSheet.addAction(report)
        actionSheet.addAction(cancel)
        
        window.rootViewController?.present(actionSheet, animated: true)
    }
    
    func processSuccessMigration() {
        UserDefaults.standard.set(0, forKey: FAILED_MIGRATION_COUNT_KEY)
    }
    
}
