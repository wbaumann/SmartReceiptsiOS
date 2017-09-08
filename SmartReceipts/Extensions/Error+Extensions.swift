//
//  Error+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
