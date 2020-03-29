//
//  Locale+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 17.03.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation

extension Locale {
    var isEurope: Bool {
        guard let code = regionCode else { return false }
        return Constants.codesEU.contains(code)
    }
    
    private enum Constants {
        static let codesEU = [
            "BE",
            "BG",
            "CZ",
            "DK",
            "DE",
            "EE",
            "IE",
            "EL",
            "ES",
            "FR",
            "HR",
            "IT",
            "CY",
            "LV",
            "LT",
            "LU",
            "HU",
            "MT",
            "NL",
            "AT",
            "PL",
            "PT",
            "RO",
            "SI",
            "SK",
            "FI",
            "SE",
            "UK",
            "IS",
            "LI",
            "NO",
            "CH"
        ]
    }
}
