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
}
