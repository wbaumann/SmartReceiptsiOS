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
    
    fileprivate let MOVE_TO_GENERATE_DISMISSED = "move.to.generate.dismissed"
    fileprivate let REPORT_GENERATED = "move.to.generate.dismissed"
    fileprivate let CONFIGURE_OCR = "ocr.configure.dismissed"
    fileprivate let PRIVACY_OPENED = "privacy.opened"
    fileprivate let PRIVACY_DISSMISED = "privacy.dissmissed"
    
    fileprivate var database: Database!
    
    private init() {
        database = Database.sharedInstance()
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
            return LocalizedString("tooltip.receipts.generate.advice")
        }
        return nil
    }
    
    func tooltipPrivacy() -> String? {
        return privacyTooltipUsed() ? nil : LocalizedString("tooltip_review_privacy")
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
    
    // Private
    private func mark(key: String) {
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func marked(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
