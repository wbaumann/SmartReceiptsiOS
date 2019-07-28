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
    
    func testCategories() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected = [WBCategory(name: "Smart Tools", code: "TOOLS")]
        let converted = converter.convertCategories(models: organization.appSettings.categories)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testPDFColumns() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected: [ReceiptColumn] = [.init(type: 14), .init(type: 11), .init(type: 15)]
        let converted = converter.convertColumns(models: organization.appSettings.pdfColumns)
        
        XCTAssertEqual(expected, converted)
    }
    
    func testCSVColumns() {
        let organizations = try! service.getOrganizations().toBlocking().single()
        let organization = organizations.first!
        
        let expected: [ReceiptColumn] = [.init(type: 14), .init(type: 15)]
        let converted = converter.convertColumns(models: organization.appSettings.csvColumns)
        
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
