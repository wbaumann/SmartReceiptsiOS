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

fileprivate let AUTH_ERROR_CODES = [401,403]

class APIProvider<T: TargetType>: MoyaProvider<T> {
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider<T>.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = MoyaProvider<T>.defaultAlamofireManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        
        var modifiedPlugins = plugins
        modifiedPlugins.append(AuthorizationPlugin())
        
        
        if DebugStates.isDebug {
            modifiedPlugins.append(NetworkLoggerPlugin(verbose: true))
        }
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: modifiedPlugins, trackInflights: trackInflights)
    }
    
    public func request(_ token: T, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return rx.request(token, callbackQueue: callbackQueue).filterSuccessfulStatusCodes()
    }
}

class AuthorizationPlugin: PluginType {
    private let bag = DisposeBag()
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .failure(let error): return Result(error: error)
        case .success(let response):
            let isAuthError = AUTH_ERROR_CODES.contains(response.statusCode)
            guard isAuthError else { return Result(value: response) }
            handleTokenError()
            return Result(error: MoyaError.statusCode(response))
        }
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    private func handleTokenError() {
        AuthService.shared.logout().subscribe().disposed(by: bag)
    }
}
