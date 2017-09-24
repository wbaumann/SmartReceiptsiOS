//
//  AuthServiceTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import RxSwift
import RxTest
import RxBlocking

let TEST_EMAIL = "aaa@aaa.aaa"
let TEST_PASSWORD = "12345678"
let TEST_CREDENTIALS = Credentials(TEST_EMAIL, TEST_PASSWORD)

class AuthServiceTests: XCTestCase {
    
    let authService = AuthService.shared
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLogin() {
        let scheduler = TestScheduler(initialClock: 0)
        let loggedInObserver = scheduler.createObserver(Bool.self)
        
        let loggedCheck = [
            next(0, false),
            next(0, true)
        ]
        
        scheduler.start()
        
        _ = authService.loggedInObservable.bind(to: loggedInObserver)
        
        let token = try! authService.login(credentials: TEST_CREDENTIALS)
            .toBlocking(timeout: 3)
            .first()!
        
        let savedToken = try! authService.tokenObservable.toBlocking().first()!
        
        XCTAssertFalse(token.isEmpty)
        XCTAssertEqual(token, savedToken)
        XCTAssertEqual(loggedCheck, loggedInObserver.events)
        XCTAssertTrue(authService.isLoggedIn)
        XCTAssertEqual(token, authService.token)
    }
    
    func testSignUp() {
        let scheduler = TestScheduler(initialClock: 0)
        let loggedInObserver = scheduler.createObserver(Bool.self)
        
        let loggedCheck = [
            next(0, false),
            next(0, true)
        ]
        
        scheduler.start()
        
        _ = authService.loggedInObservable.bind(to: loggedInObserver)
        
        let token = try! authService.signup(credentials: Credentials("5aaa@aaa.aaa", TEST_PASSWORD))
            .toBlocking(timeout: 3)
            .first()!
        
        let savedToken = try! authService.tokenObservable.toBlocking().first()!
        
        XCTAssertFalse(token.isEmpty)
        XCTAssertEqual(token, savedToken)
        XCTAssertEqual(loggedCheck, loggedInObserver.events)
        XCTAssertTrue(authService.isLoggedIn)
        XCTAssertEqual(token, authService.token)
    }
    
    func testUser() {
        _ = try? authService.login(credentials: TEST_CREDENTIALS)
            .toBlocking(timeout: 3)
            .first()
        
        let user = try? authService.getUser()
            .toBlocking(timeout: 3)
            .first()!
        
        XCTAssertNotNil(user!)
        XCTAssertFalse((user!?.cognitoToken!.isEmpty)!)
    }
    
    func testLogout() {
        _ = try? authService.login(credentials: TEST_CREDENTIALS)
            .toBlocking(timeout: 3)
            .first()
        
        let call = try? authService.logout()
            .toBlocking(timeout: 3)
            .first()
        
        XCTAssertTrue(call != nil)
    }
}
