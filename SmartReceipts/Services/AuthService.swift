//
//  AuthService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import SwiftyJSON

fileprivate let JSON_ID_KEY = "id"
fileprivate let JSON_TOKEN_KEY = "token"
fileprivate let AUTH_TOKEN_KEY = "auth.token"
fileprivate let AUTH_EMAIL_KEY = "auth.email"
fileprivate let AUTH_ID_KEY = "auth.id"

let JSON_HEADERS = ["Content-Type":"application/json"]

protocol AuthServiceInterface {
    var isLoggedIn: Bool { get }
    var loggedInObservable: Observable<Bool> { get}
    var tokenObservable: Observable<String> { get }
    var token: String { get }
    var email: String { get }
    var id: String { get }
    
    func login(credentials: Credentials) -> Observable<LoginResponse>
    func signup(credentials: Credentials) -> Observable<String>
    func logout() -> Observable<Void>
    func getUser() -> Observable<User?>
    func saveDevice(token: String) -> Observable<Void>
}

class AuthService: AuthServiceInterface {
    private let tokenVar = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: AUTH_TOKEN_KEY) ?? "")
    private let emailVar = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: AUTH_EMAIL_KEY) ?? "")
    private let idVar = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: AUTH_ID_KEY) ?? "")
    
    private let isLoggedInVar: BehaviorRelay<Bool>!
    
    private init() {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        let loggedIn = defaults.hasObject(forKey: AUTH_TOKEN_KEY) &&
                       defaults.hasObject(forKey: AUTH_EMAIL_KEY)
        isLoggedInVar = BehaviorRelay<Bool>(value: loggedIn)
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
    
    var id: String {
        let value = idVar.value
        if value.isEmpty {
            Logger.warning("ID is Empty")
        }
        return value
    }
    
    func login(credentials: Credentials) -> Observable<LoginResponse> {
        let params = ["login_params" : [
                "type": "login",
                "email" : credentials.email,
                "password": credentials.password
                ]
            ]
        
        return RxAlamofire.json(.post, endpoint("users/log_in"),
            parameters: params, encoding: JSONEncoding.default, headers: JSON_HEADERS)
            .map({ object -> LoginResponse in
                let json = JSON(object)
                let id = json[JSON_ID_KEY].stringValue
                let token = json[JSON_TOKEN_KEY].stringValue
                return LoginResponse(id, token)
            }).do(onNext: { [weak self] response in
                self?.save(token: response.token, email: credentials.email, id: response.id)
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
                self?.save(token: token, email: credentials.email, id: nil)
            })
    }
    
    func logout() -> Observable<Void> {
        if !isLoggedIn {
            return Observable<Void>.error(NSError(domain: "You are not logged in", code: 9000, userInfo: nil))
        }
        
        return APIAdapter.json(.delete, endpoint("users/log_out"), headers: nil)
            .map({ _ in  })
            .do(onNext: { self.clear() })
            .do(onError: { _ in self.clear() })
    }
    
    func getUser() -> Observable<User?> {
        return APIAdapter.json(.get, endpoint("users/me"), headers: JSON_HEADERS)
            .map({ response -> User? in
                let json = JSON(response)
                return User(json)
            })
    }
    
    func saveDevice(token: String) -> Observable<Void> {
        let params = ["user" : [ "registration_ids": [token] ] ]
        return APIAdapter.jsonBody(.patch, endpoint("users/me"), parameters: params, headers: JSON_HEADERS)
            .map({ _ in  })
    }
    
    private func save(token: String, email: String, id: String?) {
        Logger.debug("Authorized - Token: \(token) Email: \(email), ID: \(id ?? "null")")
        tokenVar.accept(token)
        emailVar.accept(email)
        idVar.accept(id ?? "")
        UserDefaults.standard.set(token, forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.set(email, forKey: AUTH_EMAIL_KEY)
        UserDefaults.standard.set(id, forKey: AUTH_ID_KEY)
        isLoggedInVar.accept(true)
    }
    
    private func clear() {
        UserDefaults.standard.removeObject(forKey: AUTH_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: AUTH_EMAIL_KEY)
        UserDefaults.standard.removeObject(forKey: AUTH_ID_KEY)
        tokenVar.accept("")
        emailVar.accept("")
        idVar.accept("")
        isLoggedInVar.accept(false)
    }
}

struct Credentials {
    var email: String
    var password: String
    
    init(_ email: String, _ password: String) {
        self.email = email
        self.password = password
    }
}

struct LoginResponse {
    var id: String
    var token: String
    
    init(_ id: String, _ token: String) {
        self.id = id
        self.token = token
    }
}

