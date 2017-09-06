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

class AuthService {
    let jsonHeader = ["Content-Type":"application/json"]
    
    func login(email: String, password: String) -> Observable<String> {
        let params = ["login_params" : [
                "type": "login",
                "email" : email,
                "password": password
                ]
            ]
        
        return RxAlamofire.json(.post, endpoint("users/log_in"),
            parameters: params, encoding: JSONEncoding.default, headers: jsonHeader)
            .map({ object -> String in
                let json = object as! JSON
                return json["token"].stringValue
            })
    }
    
    func signup(email: String, password: String) -> Observable<String> {
        let params = ["signup_params" : [
                "type": "signup",
                "email" : email,
                "password": password
                ]
            ]
        
        return RxAlamofire.json(.post, endpoint("users/sign_up"),
            parameters: params, encoding: JSONEncoding.default, headers: jsonHeader)
            .map({ object -> String in
                let json = object as! JSON
                return json["token"].stringValue
            })
    }
}

