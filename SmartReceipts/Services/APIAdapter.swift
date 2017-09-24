//
//  APIAdapter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Alamofire
import RxAlamofire
import RxSwift

class APIAdapter {
    class func json(_ method: Alamofire.HTTPMethod, _ url: URLConvertible, parameters: [String: Any]? = nil,
     encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<Any> {
        var adaptedParameters = parameters ?? [String: Any]()
        let authParams = [ "auth_params[token]": AuthService.shared.token,
                           "auth_params[email]": AuthService.shared.email]
        adaptedParameters.update(other: authParams)
        return RxAlamofire.json(method, url, parameters: adaptedParameters, encoding: encoding, headers: headers)
    }
}
