//
//  TestableExtensions.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 06/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import SwiftyJSON

extension JSON {
    static func loadFrom(filename: String, type: String?) -> JSON {
        let bundle = Bundle(for: ScanServiceTests.self)
        let path = bundle.path(forResource: filename, ofType: type)
        let jsonData = NSData(contentsOfFile: path!) as Data!
        return JSON(data: jsonData!)
    }
}
