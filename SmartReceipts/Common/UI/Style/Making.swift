//
//  Making.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

protocol Making {}

extension Making {
    func making(_ making: (inout Self)->Void) -> Self {
        var copy = self
        making(&copy)
        return copy
    }
}
