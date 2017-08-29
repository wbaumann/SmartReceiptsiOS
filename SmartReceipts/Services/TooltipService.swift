//
//  TooltipService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TooltipService {
    func tooltipText(for module: AppModules) -> String? {
        var tooltipText: String?
        switch module {
        case .receipts: tooltipText = receiptsTooltiptText()
        default: break
        }
        Logger.error("No tooltip text for module '\(module.rawValue)'")
        return tooltipText
    }
    
    private func receiptsTooltiptText() -> String? {
        return LocalizedString("tooltip.receipts.generate.advice")
    }
}
