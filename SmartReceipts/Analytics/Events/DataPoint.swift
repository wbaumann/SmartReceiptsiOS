//
//  DataPoint.swift
//  SmartReceipts
//
//  Created by Victor on 12/15/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

/// Allows us to use events with dynamic information (e.g. data points)
public struct DataPoint {
    let name: String
    let value: Any?
    
    func toString() -> String {
        // Avoid "(Optional)" string:
        var stringBuilder = "\'"
        stringBuilder.append(name)
        stringBuilder.append("\':\'")
        if let value = self.value {
            stringBuilder.append(String(describing: value))
        }
        stringBuilder.append("\'")
        
        return stringBuilder
    }
}
