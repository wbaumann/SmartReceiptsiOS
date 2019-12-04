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
        return adding([element])
    }
    
    func adding(_ items: [Element]) -> Array {
        var array = self
        items.forEach { array.append($0) }
        return array
    }
    
    func filterMap<T>(_ type: T.Type) -> Array<T> {
        return filter { $0 is T }.map { $0 as! T }
    }
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
