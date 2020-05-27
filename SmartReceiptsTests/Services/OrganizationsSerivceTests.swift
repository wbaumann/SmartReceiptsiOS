//
//  OrganizationsSerivceTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 28/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import Moya
import RxSwift
import RxOptional

class OrganizationsServiceTests: XCTestCase {
    private let bag = DisposeBag()
    private let service: OrganizationsServiceInterface = OrganizationsService.makeMockService()
    private let converter = OrganizationModelsConverter()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testPaymentMethods() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected: [PaymentMethod] = [.init(objectId: 0, method: "BITCOIN"),
                                         .init(objectId: 0, method: "LOLS"),
                                         .init(objectId: 0, method: "XAL")]
        
        let converted = converter.convertPaymentMethods(models: organization.appSettings.paymentMethods)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testParseRepsonseNotFailed() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        XCTAssertEqual(1, organizations.count)
    }
    
    func testHasError() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        XCTAssertTrue(organization.error.hasError)
        XCTAssertEqual(1, organization.error.errors.count)
        XCTAssertEqual("error1", organization.error.errors.first)
    }
    
    // MARK: CONVERT FROM MODELS
    
    func testCategoriesFromModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected = [WBCategory(name: "Smart Tools", code: "TOOLS")]
        let converted = converter.convertCategories(models: organization.appSettings.categories)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testPaymentMethodsFromModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let expected = [PaymentMethod(objectId: 0, method: "BITCOIN"), .init(objectId: 0, method: "LOLS"), .init(objectId: 0, method: "XAL")]
        let converted = converter.convertPaymentMethods(models: organizations.first!.appSettings.paymentMethods)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testPDFColumnsFromModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected: [ReceiptColumn] = [.init(type: 14), .init(type: 11), .init(type: 15)]
        let converted = converter.convertColumns(models: organization.appSettings.pdfColumns)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testCSVColumnsFromModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected: [ReceiptColumn] = [.init(type: 14), .init(type: 15)]
        let converted = converter.convertColumns(models: organization.appSettings.csvColumns)
        
        XCTAssertEqual(expected, converted)
    }
    
    // MARK: CONVERT TO MODELS
    
    func testCategoriesToModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let expected = organizations.first!.appSettings.categories
        
        let categories = converter.convertCategories(models: organizations.first!.appSettings.categories)
        let converted = converter.convertCategories(categories)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testPaymentMethodsToModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let expected = organizations.first!.appSettings.paymentMethods
        
        let paymentMethods = converter.convertPaymentMethods(models: organizations.first!.appSettings.paymentMethods)
        let converted = converter.convertPaymentMethods(paymentMethods)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testPDFColumnsToModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let expected = organizations.first!.appSettings.pdfColumns
        
        let columns = converter.convertColumns(models: organizations.first!.appSettings.pdfColumns)
        let converted = converter.convertColumns(columns)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testCSVColumnsToModels() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let expected = organizations.first!.appSettings.csvColumns
        
        let columns = converter.convertColumns(models: organizations.first!.appSettings.csvColumns)
        let converted = converter.convertColumns(columns)
        
        XCTAssertEqual(expected, converted)
    }
    
    // MARK: Import & Export
    
    func testImportExportSettings() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        let expected = try! service.getOrganizations().toBlocking().single().first!.appSettings.settings
        
        XCTAssertNotEqual(WBPreferences.settingsModel, expected)
        
        WBPreferences.importModel(settings: expected)
        
        XCTAssertEqual(WBPreferences.settingsModel, expected)
    }
    
    func testImportModels() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        let database = Database.sharedInstance()
        
        let csvUuidsBefore = (database.allCSVColumns() as! [ReceiptColumn]).map { $0.uuid }
        let pdfUuidsBefore = (database.allPDFColumns() as! [ReceiptColumn]).map { $0.uuid }
        let pmUuidsBefore = database.allPaymentMethods().map { $0.uuid }
        let catUuidsBefore = database.listAllCategories().map { $0.uuid }
        
        let organization = try! service.getOrganizations().toBlocking().single().first!
        database.importSettings(models: organization.appSettings.models)
        
        let csvUuidsAfter = (database.allCSVColumns() as! [ReceiptColumn]).map { $0.uuid }
        let pdfUuidsAfter = (database.allPDFColumns() as! [ReceiptColumn]).map { $0.uuid }
        let pmUuidsAfter = database.allPaymentMethods().map { $0.uuid }
        let catUuidsAfter = database.listAllCategories().map { $0.uuid }
        
        XCTAssertNotEqual(csvUuidsBefore, csvUuidsAfter)
        XCTAssertNotEqual(pdfUuidsBefore, pdfUuidsAfter)
        XCTAssertNotEqual(pmUuidsBefore, pmUuidsAfter)
        XCTAssertNotEqual(catUuidsBefore, catUuidsAfter)
    }
}

fileprivate extension OrganizationsService {
    static func makeMockService() -> OrganizationsService {
        let jsonData = Data.loadFrom(filename: "OrganizationsResponse", type: "json")
        
        let responseClosure = { (target: SmartReceiptsAPI) -> Endpoint in
            let url = URL(target: target).absoluteString
            return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, jsonData) }, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        
        let apiProvider = APIProvider<SmartReceiptsAPI>(endpointClosure: responseClosure, stubClosure: MoyaProvider.immediatelyStub)
        let service = OrganizationsService(api: apiProvider)
        return service
    }
}

extension ReceiptColumn: Equatable {
    open override func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? ReceiptColumn else { return false }
        return obj.name == self.name && obj.сolumnType == self.сolumnType
    }
}

extension PaymentMethod: Equatable {
    open override func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? PaymentMethod else { return false }
        return obj.method == self.method
    }
}


