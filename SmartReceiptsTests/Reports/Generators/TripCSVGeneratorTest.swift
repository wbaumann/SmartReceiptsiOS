//
//  TripCSVGeneratorTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/05/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class TripCSVGeneratorTest: SmartReceiptsTestsBase {
    
    private var generator: TripCSVGenerator!
    private var testTrip: WBTrip!
    
    override func setUp() {
        super.setUp()
        testTrip = db.insertTestTrip([AnyHashable : Any]())
        generator = TripCSVGenerator(trip: testTrip, database: self.db)
    }
    
    func testGenerateSuccess() {
        let result = generator.generate(toPath: NSTemporaryDirectory().appending("temp.csv"))
        XCTAssertTrue(result)
    }
    
    func testHasGeneratedContent() {
        let result = generator.generateContent()!
        XCTAssertFalse(result.isEmpty)
    }
    
    func testHasByteOrederMark() {
        let bytesCount = 3
        let data: NSData = generator.generateContent().data(using: .utf8)! as NSData
        var bytes = [UInt8](repeating: 0, count: bytesCount)
        data.getBytes(&bytes, length: bytesCount)
        
        let check = bytes[0] == 0xEF &&
                    bytes[1] == 0xBB &&
                    bytes[2] == 0xBF
        
        XCTAssertTrue(check)
    }
    
}
