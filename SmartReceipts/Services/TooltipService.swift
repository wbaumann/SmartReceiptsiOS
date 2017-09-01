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
        case .receipts: return receiptsTooltiptText()
        default: break
        }
        
        Logger.error("No tooltip text for module '\(module.rawValue)'")
        return nil
    }
    
    private func receiptsTooltiptText() -> String? {
        return moveToGenerateTrigger() ? LocalizedString("tooltip.receipts.generate.advice") : nil
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
    
    // Get
    func moveToGenerateTrigger() -> Bool {
        let trips = database.allTrips() as! [WBTrip]
        let justOneTrip = trips.count == 1
        let hasReceipts = database.allReceipts(for: trips.first).count > 0
        
        return !marked(key: MOVE_TO_GENERATE_DISMISSED) && !marked(key: REPORT_GENERATED) && justOneTrip && hasReceipts
    }
    
    // Private
    private func mark(key: String) {
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func marked(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
