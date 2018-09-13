//
//  AuthServiceTestable.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 06/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxSwift
import SwiftyJSON

class AuthServiceTestable: AuthServiceInterface {
    
    var negative = false
    
    var isLoggedInValue = true
    var isLoggedIn: Bool {
        return isLoggedInValue
    }
    
    var token: String { return "token"}
    
    var email: String { return TEST_CREDENTIALS.email }
    
    var id: String { return "id" }
    
    var loggedInObservable: Observable<Bool> { return negative ? .error(MockAuthError.testError) : .just(isLoggedIn) }
    
    var tokenObservable: Observable<String> { return negative ? .error(MockAuthError.testError) : .just(token) }
    
    
    func login(credentials: Credentials) -> Observable<LoginResponse> {
        return negative ? .error(MockAuthError.testError) : .just(LoginResponse(id, token))
    }
    
    func signup(credentials: Credentials) -> Observable<String> {
        return negative ? .error(MockAuthError.testError) : .just(token)
    }
    
    func logout() -> Observable<Void> {
        return negative ? .error(MockAuthError.testError) : .just(())
    }
    
    func getUser() -> Observable<User?> {
        return negative ? .error(MockAuthError.testError) : .never()
    }
    
    func saveDevice(token: String) -> Observable<Void> {
        return negative ? .error(MockAuthError.testError) : .just(())
    }
    
    enum MockAuthError: Error {
        case testError
    }
}
