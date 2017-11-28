//
//  BackupTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 28/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxBlocking
import XCTest

class BackupTests: SmartReceiptsTestsBase {
    let dataExport = DataExport(workDirectory: FileManager.documentsPath)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testImport() {
        WBPreferences.setShowReceiptID(true)
        WBPreferences.setAssumeFullPage(true)
        WBPreferences.setIncludeTaxField(false)
        WBPreferences.setCameraRotateImage(false)
        
        let exportPath = dataExport.execute()
        let dataImport = DataImport(inputFile: exportPath, output: FileManager.documentsPath)
        
        WBPreferences.setIncludeTaxField(true)
        WBPreferences.setCameraRotateImage(true)
        
        _ = try? dataImport.execute().do().toBlocking().single()
        
        XCTAssert(WBPreferences.showReceiptID())
        XCTAssert(WBPreferences.assumeFullPage())
        XCTAssertFalse(WBPreferences.includeTaxField())
        XCTAssertFalse(WBPreferences.cameraRotateImage())
    }
    
    func testExport() {
        let exportPath = dataExport.execute()
        let isFileExists = FileManager.default.fileExists(atPath: exportPath)
        XCTAssert(isFileExists)
    }
    
}
