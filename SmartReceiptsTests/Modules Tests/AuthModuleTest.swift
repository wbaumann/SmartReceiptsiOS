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

class AuthModuleTest: XCTestCase {
        
    var presenter: MockAuthPresenter!
    var interactor: MockAuthInteractor!
    var router: MockAuthRouter!
    var authService = MockAuthService().spy(on: AuthService())
    
    var result = ""
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = AuthPresenter()
        let i = AuthInteractor(authService: authService)
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
    }
    
    private func configureStubs() {
        func resultObserver() -> AnyObserver<String> {
            return AnyObserver<String>(eventHandler: { event in
                switch event {
                case .next(let element):
                    self.result = element
                default: break
                }
                
            })
        }
        
        func resultVoidObserver() -> AnyObserver<Void> {
            return AnyObserver<Void>(eventHandler: { event in
                switch event {
                case .next:
                    self.result = "Success"
                default: break
                }
                
            })
        }
        
        stub(presenter) { mock in
            mock.successLogin.get.thenReturn(resultObserver())
            mock.successSignup.get.thenReturn(resultObserver())
            mock.errorHandler.get.thenReturn(resultObserver())
            mock.successLogout.get.thenReturn(resultVoidObserver())
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessRequests() {
        stub(authService) { mock in
            mock.login(credentials: self.credentials()).thenReturn(Observable.just("successLogin"))
            mock.signup(credentials: self.credentials()).thenReturn(Observable.just("successSignup"))
        }
        
        Observable.just(credentials())
            .bind(to: interactor.login)
            .disposed(by: bag)
        XCTAssertEqual("successLogin", result)
        
        Observable.just(credentials())
            .bind(to: interactor.signup)
            .disposed(by: bag)
        XCTAssertEqual("successSignup", result)
    }
    
    func testInvalidCredentialsError() {
        stub(authService) { mock in
            let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
            mock.login(credentials: self.credentials()).thenReturn(Observable.error(error))
        }
        Observable.just(credentials())
            .bind(to: interactor.login)
            .disposed(by: bag)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testExistEmailError() {
        stub(authService) { mock in
            let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 420))
            mock.signup(credentials: self.credentials()).thenReturn(Observable.error(error))
        }
        Observable.just(credentials())
            .bind(to: interactor.signup)
            .disposed(by: bag)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testLogoutSuccess() {
        stub(authService) { mock in
            mock.logout().thenReturn(Observable.just())
        }
        interactor.logout.onNext()
        XCTAssertEqual("Success", result)
    }
    
    func testLogoutError() {
        stub(authService) { mock in
            let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 400))
            mock.logout().thenReturn(Observable.error(error))
        }
        interactor.logout.onNext()
        XCTAssertFalse(result.isEmpty)
    }
    
    private func credentials() -> Credentials { return Credentials("","") }
    
}
