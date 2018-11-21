//
//  TestableExtensions.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 06/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

extension Decodable {
    static func loadFrom(filename: String, type: String?) -> Self {
        let data = Data.loadFrom(filename: filename, type: type)
        return try! JSONDecoder.iso8601.decode(Self.self, from: data)

    }
}

extension Data {
    static func loadFrom(filename: String, type: String?) -> Data {
        let bundle = Bundle(for: ScanServiceTests.self)
        let path = bundle.path(forResource: filename, ofType: type)
        return try! NSData(contentsOfFile: path!) as Data
    }
}

prefix operator ++
prefix operator --
prefix func ++<T: Numeric> (_ val: inout T) -> T {
    val += 1
    return val
}

prefix func --<T: Numeric> (_ val: inout T) -> T {
    val -= 1
    return val
}

postfix operator ++
postfix operator --
postfix func ++<T: Numeric> (_ val: inout T) -> T {
    defer { val += 1 }
    return val
}

postfix func --<T: Numeric> (_ val: inout T) -> T {
    defer { val -= 1 }
    return val
}
