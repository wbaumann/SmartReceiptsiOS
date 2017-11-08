//
//  ScanTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 08/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import SwiftyJSON

class ScanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidJSONParse() {
        let json = JSON.loadFrom(filename: "Scan", type: "json")
        let scan = Scan(json: json, image: UIImage())
        
        XCTAssertNotNil(scan.merchant)
        XCTAssertNotNil(scan.taxAmount)
        XCTAssertNotNil(scan.totalAmount)
        XCTAssertNotNil(scan.date)
    }
    
    func testInvalidJSONParse() {
        let scan = Scan(json: JSON(), image: UIImage())
        
        XCTAssertNil(scan.merchant)
        XCTAssertNil(scan.taxAmount)
        XCTAssertNil(scan.totalAmount)
        XCTAssertNil(scan.date)
    }
    
    func testPartlyValidJSONParse() {
        var json = JSON.loadFrom(filename: "Scan", type: "json")
        json["recognition"]["data"].dictionaryObject?.removeValue(forKey: "recognition_data")
        let scan = Scan(json: json, image: UIImage())
        
        XCTAssertNil(scan.merchant)
        XCTAssertNil(scan.taxAmount)
        XCTAssertNil(scan.totalAmount)
        XCTAssertNil(scan.date)
    }
    
    func testSomeFieldsJSONParse() {
        var json = JSON.loadFrom(filename: "Scan", type: "json")
        json["recognition"]["data"]["recognition_data"].dictionaryObject?.removeValue(forKey: "taxAmount")
        json["recognition"]["data"]["recognition_data"].dictionaryObject?.removeValue(forKey: "date")
        let scan = Scan(json: json, image: UIImage())
        
        XCTAssertNotNil(scan.merchant)
        XCTAssertNil(scan.taxAmount)
        XCTAssertNotNil(scan.totalAmount)
        XCTAssertNil(scan.date)
    }
}
