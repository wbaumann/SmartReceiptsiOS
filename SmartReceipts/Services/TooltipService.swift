//
//  TooltipService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class TooltipService {
    private let bag = DisposeBag()
    
    fileprivate let MOVE_TO_GENERATE_DISMISSED = "move.to.generate.dismissed"
    fileprivate let REPORT_GENERATED = "move.to.generate.dismissed"
    fileprivate let CONFIGURE_OCR = "ocr.configure.dismissed"
    fileprivate let PRIVACY_OPENED = "privacy.opened"
    fileprivate let PRIVACY_DISSMISED = "privacy.dissmissed"
    fileprivate let REMINDER_DATE = "reminder.date"
    fileprivate let REMINDER_INSERTS = "reminder.inserts"
    
    fileprivate let MIN_INSERTS_COUNT = 15
    fileprivate let MIN_DAYS_COUNT = 10
    
    fileprivate var database: Database!
    
    private init() {
        database = Database.sharedInstance()
        NotificationCenter.default.addObserver(self, selector: #selector(didInsert(_:)), name: .DatabaseDidInsertModel, object: nil)
        AppNotificationCenter.didSyncBackup.subscribe(onNext: { [weak self] in
            self?.markBackup()
        }).disposed(by: bag)
    }
    
    static let shared = TooltipService()
    
    static func service(for db: Database) -> TooltipService {
        let service = TooltipService()
        service.database = db
        return service
    }
    
    func tooltipText(for module: AppModules) -> String? {
        
        switch module {
        case .trips: return tooltipPrivacy()
        default: break
        }
        
        Logger.error("No tooltip text for module '\(module.rawValue)'")
        return nil
    }
    
    func generateTooltip(for trip: WBTrip) -> String? {
        if moveToGenerateTrigger(for: trip) {
            return LocalizedString("tooltip_generate_info_message")
        }
        return nil
    }
    
    func tooltipBackupReminder() -> String? {
        if needRemindByInserts() {
            let timeInterval = UserDefaults.standard.double(forKey: REMINDER_DATE)
            if timeInterval == 0 {
                return LocalizedString("tooltip_no_backups_info_message")
            } else if needRemindByDays() {
                let backupDate = Date(timeIntervalSince1970: timeInterval)
                let days = Date().daysDifference(date: backupDate)
                return String(format: LocalizedString("tooltip_backup_info_message"), days)
            }
        }
        return nil
    }
    
    func tooltipPrivacy() -> String? {
        return privacyTooltipUsed() ? nil : LocalizedString("tooltip_review_privacy")
    }
    
    @objc private func didInsert(_ notification: Notification) {
        let inserts = UserDefaults.standard.integer(forKey: REMINDER_INSERTS) + 1
        UserDefaults.standard.set(inserts, forKey: REMINDER_INSERTS)
    }
}

//MARK: Triggers
extension TooltipService {
    
    // Mark
    func markMoveToGenerateDismiss() {
        mark(key: MOVE_TO_GENERATE_DISMISSED)
    }
    
    func markReportGenerated() {
        mark(key: REPORT_GENERATED)
    }
    
    func markConfigureOCRDismissed() {
        mark(key: CONFIGURE_OCR)
    }
    
    func markPrivacyOpened() {
        mark(key: PRIVACY_OPENED)
    }
    
    func markPrivacyDismissed() {
        mark(key: PRIVACY_DISSMISED)
    }
    
    func markBackupReminderDismissed() {
        UserDefaults.standard.set(0, forKey: REMINDER_INSERTS)
    }
    
    func markBackup() {
        UserDefaults.standard.set(0, forKey: REMINDER_INSERTS)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: REMINDER_DATE)
    }
    
    // Get
    func moveToGenerateTrigger(for trip: WBTrip) -> Bool {
        let hasReceipts = database.allReceipts(for: trip).count > 0
        return !marked(key: MOVE_TO_GENERATE_DISMISSED) && !marked(key: REPORT_GENERATED) && hasReceipts
    }
    
    func configureOCRDismissed() -> Bool {
        return marked(key: CONFIGURE_OCR)
    }
    
    func privacyTooltipUsed() -> Bool {
        return marked(key: PRIVACY_OPENED) || marked(key: PRIVACY_DISSMISED)
    }
    
    fileprivate func needRemindByDays() -> Bool {
        let timeInterval = UserDefaults.standard.double(forKey: REMINDER_DATE)
        if timeInterval != 0 { return false }
        let backupDate = Date(timeIntervalSince1970: timeInterval)
        return Date().daysDifference(date: backupDate) >= MIN_DAYS_COUNT
    }
    
    fileprivate func needRemindByInserts() -> Bool {
        let inserts = UserDefaults.standard.integer(forKey: REMINDER_INSERTS)
        return inserts >= MIN_INSERTS_COUNT
    }
    
    // Private
    private func mark(key: String) {
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func marked(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
