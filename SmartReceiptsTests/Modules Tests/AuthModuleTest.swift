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

class AuthModuleTest: XCTestCase {
        
    var presenter: MockAuthPresenter!
    var interactor: MockAuthInteractor!
    var router: MockAuthRouter!
    
    var result = ""
    var expectation: XCTestExpectation!
    
    let bag = DisposeBag()
    
    
    var resultObserver: AnyObserver<String>!
    var resultVoidObserver: AnyObserver<Void>!
    
    override func setUp() {
        super.setUp()
        
        let p = AuthPresenter()
        let i = AuthInteractor()
        let r = AuthRouter()
        
        var module = AppModules.auth.build()
        module.injectMock(presenter: MockAuthPresenter().spy(on: p))
        module.injectMock(interactor: MockAuthInteractor().spy(on: i))
        module.injectMock(router: MockAuthRouter().spy(on: r))
        
        presenter = module.presenter as! MockAuthPresenter
        interactor = module.interactor as! MockAuthInteractor
        router = module.router as! MockAuthRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        i._presenter = presenter
        r._presenter = presenter
        
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
            mock.successLogin.get.thenReturn(resultObserver)
            mock.successSignup.get.thenReturn(resultObserver)
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
        Observable.just(Credentials("aaa1@aaa.aa", TEST_PASSWORD))
            .bind(to: self.interactor.signup)
            .disposed(by: self.bag)
        
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testInvalidCredentialsError() {
        let invalidCredentials = Credentials(TEST_EMAIL,"12121212")
        Observable.just(invalidCredentials)
            .bind(to: interactor.login)
            .disposed(by: bag)
        
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testExistEmailError() {
        Observable.just(TEST_CREDENTIALS)
            .bind(to: interactor.signup)
            .disposed(by: bag)
        
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testLogoutSuccess() {
        _ = try? AuthService.shared.login(credentials: TEST_CREDENTIALS).toBlocking(timeout: TIME_OUT).single()
        interactor.logout.onNext()
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertEqual("ok", result)
    }
    
    func testLogoutError() {
        _ = try? AuthService.shared.logout().toBlocking(timeout: 10).single()
        interactor.logout.onNext()
        wait(for: [expectation], timeout: TIME_OUT)
        XCTAssertFalse(result.isEmpty)
    }
    
    
}
