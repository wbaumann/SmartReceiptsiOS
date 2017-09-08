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

//typealias Credentials = ()



fileprivate let JSON_TOKEN_KEY = "token"
fileprivate let AUTH_TOKEN_KEY = "auth.token"
fileprivate let AUTH_EMAIL_KEY = "auth.email"

class AuthService {
    private let jsonHeader = ["Content-Type":"application/json"]
    private let tokenVar = Variable<String>("")
    
    static private let isLoggedInVar = Variable<Bool?>(nil)
    
    static var isLoggedIn: Observable<Bool> {
        return isLoggedInVar
            .asObservable()
            .map({ value -> Bool in
                if value == nil {
                    let defaults = UserDefaults.standard
                    defaults.synchronize()
                    return defaults.hasObject(forKey: AUTH_TOKEN_KEY) && defaults.hasObject(forKey: AUTH_EMAIL_KEY)
                } else {
                    return value!
                }
            })
    }
    
    init() {
        tokenVar.value = UserDefaults.standard.string(forKey: AUTH_TOKEN_KEY) ?? ""
    }
    
    var token: Observable<String> {
        return tokenVar.asObservable().filter({ !$0.isEmpty })
    }
    
    func login(credentials: Credentials) -> Observable<String> {
        let params = ["login_params" : [
                "type": "login",
                "email" : credentials.email,
                "password": credentials.password
                ]
            ]
        
        return RxAlamofire.json(.post, endpoint("users/log_in"),
            parameters: params, encoding: JSONEncoding.default, headers: jsonHeader)
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
            parameters: params, encoding: JSONEncoding.default, headers: jsonHeader)
            .map({ object -> String in
                let json = JSON(object)
                return json[JSON_TOKEN_KEY].stringValue
            }).do(onNext: { [weak self] token in
                self?.save(token: token, email: credentials.email)
            })
    }
    
    private func save(token: String, email: String) {
        AuthService.isLoggedInVar.value = true
        tokenVar.value = token
        UserDefaults.standard.set(token, forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.set(email, forKey: AUTH_EMAIL_KEY)
    }
    
    private func clear() {
        AuthService.isLoggedInVar.value = false
        UserDefaults.standard.removeObject(forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: AUTH_EMAIL_KEY)
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

