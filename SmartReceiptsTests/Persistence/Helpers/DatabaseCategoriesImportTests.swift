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
    fileprivate var pathToImport: String!
    fileprivate var databasePath: String!
    fileprivate var database: Database!
    
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
        let countBefore = database.countRows(inTable: CategoriesTable.Name)
        XCTAssertEqual(24, countBefore)
        
        database.importData(fromBackup: pathToImport, overwrite: true)
        
        let countAfter = database.countRows(inTable: CategoriesTable.Name)
        XCTAssertEqual(24, countAfter)
        
        let categories = database.listAllCategories()
        XCTAssertNil(categoryByName("Airfare", categories: categories!), "Should have no category named Airfare")
        XCTAssertNotNil(categoryByName("Cakes", categories: categories!), "Should have imported category named Cakes")
    }
    
    func testCategoriesImportWithoutOverwrite() {
        let countBefore = database.countRows(inTable: CategoriesTable.Name)
        XCTAssertEqual(24, countBefore)

        database.importData(fromBackup: pathToImport, overwrite: false)
        
        let countAfter = database.countRows(inTable: CategoriesTable.Name)
        XCTAssertEqual(25, countAfter)
        
        let categories = database.listAllCategories()
        XCTAssertNotNil(categoryByName("Airfare", categories: categories!), "Should have previous category named Airfare")
        XCTAssertNotNil(categoryByName("Cakes", categories: categories!), "Should have imported category named Cakes")
    }
    
    fileprivate func categoryByName(_ name: String, categories: [WBCategory]) -> WBCategory? {
        return categories.filter({ $0.name == name }).first
    }
    
    fileprivate func copyTemplateDatabase(_ name: String) -> String {
        let templatePath = Bundle(for: DatabaseCategoriesImportTests.self).path(forResource: name, ofType: "db")!
        let target = NSTemporaryDirectory() + "database-\(UUID().uuidString).db"
        try! FileManager.default.copyItem(atPath: templatePath, toPath: target)
        return target
    }
    
    fileprivate func removeFiles(_ paths: [String]) {
        for path in paths {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
}
