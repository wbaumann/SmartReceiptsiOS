//
//  ScanTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 08/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest

private let FAKE_URL = URL(fileURLWithPath: "")

class ScanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidJSONParse() {
        let response = RecognitionResponse.loadFrom(filename: "RecognitionResponse", type: "json")
        let scanResult = ScanResult(recognition: response.recognition, filepath: FAKE_URL)
        
        XCTAssertNotNil(scanResult.recognition)
        XCTAssertEqual(scanResult.recognition?.result.data.totalAmount?.data, 23.66)
        XCTAssertNil(scanResult.recognition?.result.data.taxAmount?.data)
        XCTAssertNotNil(scanResult.recognition?.result.data.date?.data)
        XCTAssertEqual(scanResult.recognition?.result.data.merchantName?.data, "Walmart")
        XCTAssertEqual(scanResult.recognition?.result.data.merchantAddress?.data, "3500 east main, 54452, Merrill, Россия")
        XCTAssertEqual(scanResult.recognition?.result.data.merchantCity?.data, "Merrill")
        XCTAssertEqual(scanResult.recognition?.result.data.merchantState?.data, "Wi")
        XCTAssertEqual(scanResult.recognition?.result.data.merchantCountryCode?.data, "RU")
        XCTAssertEqual(scanResult.recognition?.result.data.merchantTypes?.data, ["Miscellaneous Shop"])
    }
    
    func testDataEmptyJSONParse() {
        let response = RecognitionResponse.loadFrom(filename: "RecognitionResponseEmpty", type: "json")
        let scanResult = ScanResult(recognition: response.recognition, filepath: FAKE_URL)
        
        XCTAssertNotNil(scanResult.recognition)
        XCTAssertNil(scanResult.recognition?.result.data.totalAmount)
        XCTAssertNil(scanResult.recognition?.result.data.taxAmount)
        XCTAssertNil(scanResult.recognition?.result.data.date)
        XCTAssertNil(scanResult.recognition?.result.data.merchantName)
        XCTAssertNil(scanResult.recognition?.result.data.merchantAddress)
        XCTAssertNil(scanResult.recognition?.result.data.merchantCity)
        XCTAssertNil(scanResult.recognition?.result.data.merchantState)
        XCTAssertNil(scanResult.recognition?.result.data.merchantCountryCode)
        XCTAssertNil(scanResult.recognition?.result.data.merchantTypes)
        
    }
}
