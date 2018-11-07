//
//  APIProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift
import Moya
import Result

fileprivate let TOKEN_ERROR_CODE = 401

class APIProvider<T: TargetType>: MoyaProvider<T> {
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider<T>.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = MoyaProvider<T>.defaultAlamofireManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        
        var modifiedPlugins = plugins
        modifiedPlugins.append(NetworkLoggerPlugin(verbose: true))
        modifiedPlugins.append(AuthorizationPlugin())
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: modifiedPlugins, trackInflights: trackInflights)
    }
}

class AuthorizationPlugin: PluginType {
    private let bag = DisposeBag()
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            if response.statusCode == TOKEN_ERROR_CODE { handleTokenError() }
        case .failure(let error):
            if error.code == TOKEN_ERROR_CODE { handleTokenError() }
        }
        return result
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    private func handleTokenError() {
        AuthService.shared.logout().subscribe().disposed(by: bag)
    }
}
