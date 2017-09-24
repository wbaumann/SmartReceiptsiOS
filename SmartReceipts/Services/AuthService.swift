//
//  AuthService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire
import SwiftyJSON

fileprivate let JSON_TOKEN_KEY = "token"
fileprivate let AUTH_TOKEN_KEY = "auth.token"
fileprivate let AUTH_EMAIL_KEY = "auth.email"

let JSON_HEADERS = ["Content-Type":"application/json"]

class AuthService {
    private let tokenVar = Variable<String>(UserDefaults.standard.string(forKey: AUTH_TOKEN_KEY) ?? "")
    private let emailVar = Variable<String>(UserDefaults.standard.string(forKey: AUTH_EMAIL_KEY) ?? "")
    
    private let isLoggedInVar: Variable<Bool>!
    
    private init() {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        let loggedIn = defaults.hasObject(forKey: AUTH_TOKEN_KEY) &&
                       defaults.hasObject(forKey: AUTH_EMAIL_KEY)
        isLoggedInVar = Variable<Bool>(loggedIn)
    }
    
    static let shared = AuthService()
    
    var loggedInObservable: Observable<Bool> {
        return isLoggedInVar.asObservable()
    }
    
    var isLoggedIn: Bool {
        return isLoggedInVar.value
    }
    
    var tokenObservable: Observable<String> {
        return tokenVar.asObservable().filter({ !$0.isEmpty })
    }
    
    var token: String {
        let value = tokenVar.value
        if value.isEmpty {
            Logger.warning("Token is Empty")
        }
        return value
    }
    
    var email: String {
        let value = emailVar.value
        if value.isEmpty {
            Logger.warning("Email is Empty")
        }
        return value
    }
    
    func login(credentials: Credentials) -> Observable<String> {
        let params = ["login_params" : [
                "type": "login",
                "email" : credentials.email,
                "password": credentials.password
                ]
            ]
        
        return RxAlamofire.json(.post, endpoint("users/log_in"),
            parameters: params, encoding: JSONEncoding.default, headers: JSON_HEADERS)
            .map({ object -> String in
                let json = JSON(object)
                return json[JSON_TOKEN_KEY].stringValue
            }).do(onNext: { [weak self] token in
                self?.save(token: token, email: credentials.email)
            })
    }
    
    func signup(credentials: Credentials) -> Observable<String> {
        let params = ["signup_params" : [
                "type": "signup",
                "email" : credentials.email,
                "password": credentials.password
                ]
            ]
        
        return RxAlamofire.json(.post, endpoint("users/sign_up"),
            parameters: params, encoding: JSONEncoding.default, headers: JSON_HEADERS)
            .map({ object -> String in
                let json = JSON(object)
                return json[JSON_TOKEN_KEY].stringValue
            }).do(onNext: { [weak self] token in
                self?.save(token: token, email: credentials.email)
            })
    }
    
    func logout() -> Observable<Void> {
        if !isLoggedIn {
            return Observable<Void>.error(NSError(domain: "You are not logged in", code: 9000, userInfo: nil))
        }
        
        return APIAdapter.json(.delete, endpoint("users/log_out"), headers: nil)
            .map({ _ in  })
            .do(onNext: {
                self.clear()
            })
    }
    
    func getUser() -> Observable<User?> {
        return APIAdapter.json(.get, endpoint("users/me"), headers: JSON_HEADERS)
            .map({ response -> User? in
                let json = JSON(response)
                return User(json)
            })
    }
    
    private func save(token: String, email: String) {
        Logger.debug("Authorized - Token: \(token) Email: \(email)")
        tokenVar.value = token
        emailVar.value = email
        UserDefaults.standard.set(token, forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.set(email, forKey: AUTH_EMAIL_KEY)
        isLoggedInVar.value = true
    }
    
    private func clear() {
        UserDefaults.standard.removeObject(forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: AUTH_EMAIL_KEY)
        tokenVar.value = ""
        emailVar.value = ""
        isLoggedInVar.value = false
    }
}

struct Credentials {
    var email: String!
    var password: String!
    
    init(_ email: String, _ password: String) {
        self.email = email
        self.password = password
    }
}

