//
//  DatabaseCategoriesImportTests.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

class DatabaseCategoriesImportTests: XCTestCase {
    private var pathToImport: String!
    private var databasePath: String!
    private var database: Database!
    
    override func setUp() {
        super.setUp()

        pathToImport = copyTemplateDatabase("exrtas-import-test")
        databasePath = copyTemplateDatabase("clean")
        database = Database(databasePath: databasePath, tripsFolderPath: NSTemporaryDirectory())
        database.open()
    }
    
    override func tearDown() {
        database.close()
        removeFiles([pathToImport, databasePath])
        super.tearDown()
    }
    
    func testCategoriesImportWithOverwrite() {
        let countBefore = database.countRowsInTable(CategoriesTable.Name)
        XCTAssertEqual(24, countBefore)
        
        database.importDataFromBackup(pathToImport, overwrite: true)
        
        let countAfter = database.countRowsInTable(CategoriesTable.Name)
        XCTAssertEqual(24, countAfter)
        
        let categories = database.listAllCategories()
        XCTAssertNil(categoryByName("Airfare", categories: categories), "Should have no category named Airfare")
        XCTAssertNotNil(categoryByName("Cakes", categories: categories), "Should have imported category named Cakes")
    }
    
    func testCategoriesImportWithoutOverwrite() {
        let countBefore = database.countRowsInTable(CategoriesTable.Name)
        XCTAssertEqual(24, countBefore)

        database.importDataFromBackup(pathToImport, overwrite: false)
        
        let countAfter = database.countRowsInTable(CategoriesTable.Name)
        XCTAssertEqual(25, countAfter)
        
        let categories = database.listAllCategories()
        XCTAssertNotNil(categoryByName("Airfare", categories: categories), "Should have previous category named Airfare")
        XCTAssertNotNil(categoryByName("Cakes", categories: categories), "Should have imported category named Cakes")
    }
    
    private func categoryByName(name: String, categories: [WBCategory]) -> WBCategory? {
        return categories.filter({ $0.name == name }).first
    }
    
    private func copyTemplateDatabase(name: String) -> String {
        let templatePath = NSBundle(forClass: DatabaseCategoriesImportTests.self).pathForResource(name, ofType: "db")!
        let target = NSTemporaryDirectory().stringByAppendingString("database-\(NSUUID().UUIDString).db")
        try! NSFileManager.defaultManager().copyItemAtPath(templatePath, toPath: target)
        return target
    }
    
    private func removeFiles(paths: [String]) {
        for path in paths {
            try! NSFileManager.defaultManager().removeItemAtPath(path)
        }
    }
}
