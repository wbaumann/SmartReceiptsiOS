//
//  UserDefaults+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

extension UserDefaults {
    func hasObject(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
