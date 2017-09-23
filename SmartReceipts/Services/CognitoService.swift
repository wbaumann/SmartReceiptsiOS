//
//  CognitoService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import AWSCore
import RxSwift

class CognitoService: AWSCognitoCredentialsProviderHelper {
    private let userVar = Variable<User?>(nil)
    private let authService = AuthService()
    private let bag = DisposeBag()
    
    override init() {
        super.init(regionType: .USEast1, identityPoolId: "us-east-1:cdcc971a-b67f-4bc0-9a12-291b5d416518", useEnhancedFlow: true, identityProviderManager: nil)
    
        AuthService.loggedInObservable
            .filter({ $0 })
            .flatMap({ [unowned self] _ in
                return self.authService.getUser().catchErrorJustReturn(nil)
            }).bind(to: userVar)
            .disposed(by: bag)
    }
    
    override var identityProviderName: String {
        return "cognito-identity.amazonaws.com"
    }
    
    override func token() -> AWSTask<NSString> {
        if let user = userVar.value, AuthService.isLoggedIn {
            identityId = user.identityId
            return AWSTask(result: NSString(string: user.cognitoToken!))
        } else {
            return AWSTask(result:nil)
        }
    }
    
    override func logins() -> AWSTask<NSDictionary> {
        if AuthService.isLoggedIn {
            return super.logins()
        } else {
            return AWSTask(result:nil)
        }
    }
    
    override func clear() {
        super.clear()
        authService.getUser()
            .bind(to: userVar)
            .disposed(by: bag)
    }
}

