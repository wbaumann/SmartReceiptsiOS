//
//  AuthModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import RxTest
import XCTest
import RxBlocking
import Alamofire

fileprivate let TIME_OUT: TimeInterval = 10
let TEST_CREDENTIALS = Credentials("hello@world.com", "123")

class AuthModuleTest: XCTestCase {
        
    var presenter: MockAuthPresenter!
    var interactor: MockAuthInteractor!
    var router: MockAuthRouter!
    var authService = AuthServiceTestable()
    
    var result = ""
    var expectation: XCTestExpectation!
    
    let bag = DisposeBag()
    
    var resultObserver: AnyObserver<String>!
    var resultVoidObserver: AnyObserver<Void>!
    
    override func setUp() {
        super.setUp()
        
        authService.negative = false
        
        var module = AppModules.auth.build()
        module.injectMock(presenter: MockAuthPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockAuthInteractor(authService: authService).withEnabledSuperclassSpy())
        module.injectMock(router: MockAuthRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! MockAuthPresenter
        interactor = module.interactor as! MockAuthInteractor
        router = module.router as! MockAuthRouter
        
        configureStubs()
        result = ""
        expectation = expectation(description: "Request waiting")
    }
    
    private func configureStubs() {
        resultObserver = AnyObserver<String>(onNext: { element in
            self.result = element
            self.expectation.fulfill()
        })
        
        resultVoidObserver =  AnyObserver<Void>(onNext: {
            self.result = "ok"
            self.expectation.fulfill()
        })
        
        stub(presenter) { mock in
            mock.successLogin.get.thenReturn(resultVoidObserver)
            mock.successSignup.get.thenReturn(resultVoidObserver)
            mock.errorHandler.get.thenReturn(resultObserver)
            mock.successLogout.get.thenReturn(resultVoidObserver)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessLogin() {
        Observable.just(TEST_CREDENTIALS)
            .bind(to: self.interactor.login)
            .disposed(by: self.bag)

        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }

    func testSuccessSignup() {
        Observable.just(TEST_CREDENTIALS)
            .bind(to: self.interactor.signup)
            .disposed(by: self.bag)

        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }

    func testInvalidCredentialsError() {
        authService.negative = true
        
        Observable.just(TEST_CREDENTIALS)
            .bind(to: interactor.login)
            .disposed(by: bag)

        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }

    func testExistEmailError() {
        authService.negative = true
        
        Observable.just(TEST_CREDENTIALS)
            .bind(to: interactor.signup)
            .disposed(by: bag)

        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }

    func testLogoutSuccess() {
        _ = try? authService.login(credentials: TEST_CREDENTIALS).toBlocking(timeout: TIME_OUT).single()
        interactor.logout.onNext(())
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertEqual("ok", result)
    }

    func testLogoutError() {
        authService.negative = true
        
        _ = try? authService.logout().toBlocking(timeout: 10).single()
        interactor.logout.onNext(())
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }
}
