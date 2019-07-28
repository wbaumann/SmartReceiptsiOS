//
//  AuthServiceTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 22/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import Moya
import RxSwift

class AuthServiceTests: XCTestCase {
    private let bag = DisposeBag()
    
    override func setUp() {
        //Clear Credentials
        makeAuthService(response: .networkResponse(200, Data())).logout().subscribe().disposed(by: bag)
    }

    override func tearDown() {
        
    }

    func testLoginCredentialsSaved() {
        let jsonData = Data.loadFrom(filename: "LoginResponse", type: "json")
        let authService = makeAuthService(response: .networkResponse(200, jsonData))
        
        XCTAssertTrue(authService.id.isEmpty)
        XCTAssertTrue(authService.token.isEmpty)
        
        authService.login(credentials: TEST_CREDENTIALS).subscribe().disposed(by: bag)
        
        XCTAssertEqual("12345", authService.id)
        XCTAssertEqual("aaaaa", authService.token)
    }
    
    func testSignupCredentialsSaved() {
        let jsonData = Data.loadFrom(filename: "SignupResponse", type: "json")
        let authService = makeAuthService(response: .networkResponse(200, jsonData))
        
        XCTAssertTrue(authService.id.isEmpty)
        XCTAssertTrue(authService.token.isEmpty)
        
        authService.signup(credentials: TEST_CREDENTIALS).subscribe().disposed(by: bag)
        
        XCTAssertEqual("54321", authService.id)
        XCTAssertEqual("bbbbb", authService.token)
    }
    
    func testCredentialsNotSaved() {
        let authService = makeAuthService(response: .networkError(FakeError()))
        
        XCTAssertTrue(authService.id.isEmpty)
        XCTAssertTrue(authService.token.isEmpty)
        
        authService.login(credentials: TEST_CREDENTIALS).subscribe().disposed(by: bag)
        
        XCTAssertTrue(authService.id.isEmpty)
        XCTAssertTrue(authService.token.isEmpty)
        
        authService.signup(credentials: TEST_CREDENTIALS).subscribe().disposed(by: bag)
        
        XCTAssertTrue(authService.id.isEmpty)
        XCTAssertTrue(authService.token.isEmpty)
    }
    
    func testGetUser() {
        let jsonData = Data.loadFrom(filename: "UserResponse", type: "json")
        let authService = makeAuthService(response: .networkResponse(200, jsonData))
        
        let user = try! authService.getUser().toBlocking().single()
        
        XCTAssertEqual("123", user.id)
        XCTAssertEqual("hello@test.com", user.email)
        XCTAssertEqual("name", user.name)
        XCTAssertEqual("displayName", user.displayName)
        XCTAssertEqual("provider", user.provider)
        XCTAssertEqual("1", user.registrationIds?.first)
        XCTAssertEqual("cognitoToken", user.cognitoToken)
        XCTAssertEqual("identityId", user.identityId)
        XCTAssertEqual(100, user.recognitionsAvailable)
    }
    
    private func makeAuthService(response: EndpointSampleResponse) -> AuthService {
        let responseClosure = { (target: SmartReceiptsAPI) -> Endpoint in
            let url = URL(target: target).absoluteString
            return Endpoint(url: url, sampleResponseClosure: { response }, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        
        let apiProvider = APIProvider<SmartReceiptsAPI>(endpointClosure: responseClosure, stubClosure: MoyaProvider.immediatelyStub)
        let authService = AuthService(apiProvider: apiProvider)
        return authService
    }
}

fileprivate class FakeError: NSError {
    convenience init() {
        self.init(domain: "fake", code: 400, userInfo: nil)
    }
}
