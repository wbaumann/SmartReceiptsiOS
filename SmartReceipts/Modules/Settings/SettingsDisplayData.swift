//
//  SettingsDisplayData.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class SettingsDisplayData: DisplayData {
    var showSettingsOption: ShowSettingsOption?
    
    let formats: [String] = [
        .format(.monthDayYear, "/"),
        .format(.dayMonthYear, "/"),
        .format(.yearMonthDay, "/"),
        
        .format(.monthDayYear, "-"),
        .format(.dayMonthYear, "-"),
        .format(.yearMonthDay, "-"),
        
        .format(.monthDayYear, "."),
        .format(.dayMonthYear, "."),
        .format(.yearMonthDay, ".")
    ]
}

enum DateFormat {
    case dayMonthYear
    case monthDayYear
    case yearMonthDay
    
    func format(separator: String) -> String {
        switch self {
        case .dayMonthYear: return ["dd", "MM", "YYYY"].joined(separator: separator)
        case .monthDayYear: return ["MM", "dd", "YYYY"].joined(separator: separator)
        case .yearMonthDay: return ["YYYY", "MM", "dd"].joined(separator: separator)
        }
    }
}

private extension String {
    static func format(_ format: DateFormat, _ separator: String) -> String {
        return format.format(separator: separator)
    }
}
