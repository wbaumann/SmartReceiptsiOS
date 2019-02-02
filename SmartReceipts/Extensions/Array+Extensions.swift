//
//  Array+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 26/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

extension Array {
    func adding(_ element: Element) -> Array {
        var array = self
        array.append(element)
        return array
    }
    
    func filterMap<T>(_ type: T.Type) -> Array<T> {
        return filter { $0 is T }.map { $0 as! T }
    }
}
