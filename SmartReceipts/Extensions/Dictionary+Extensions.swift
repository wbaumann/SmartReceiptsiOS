//
//  Dictionary+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(other: Dictionary?) {
        if other == nil { return }
        for (key,value) in other! {
            self.updateValue(value, forKey:key)
        }
    }
}
