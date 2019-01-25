//
//  CognitoService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import AWSCore
import RxSwift

fileprivate let COGNITO_TOKEN_KEY = "cognito.token"
fileprivate let COGNITO_IDENTITY_ID_KEY = "cognito.identity.id"

class CognitoService: AWSCognitoCredentialsProviderHelper {
    private let bag = DisposeBag()
    
    override init() {
        super.init(regionType: .USEast1, identityPoolId: "us-east-1:cdcc971a-b67f-4bc0-9a12-291b5d416518", useEnhancedFlow: true, identityProviderManager: nil)
    
        AuthService.shared.loggedInObservable
            .filter { $0 }
            .flatMap { _ in return AuthService.shared.getUser() }
            .subscribe(onNext: { [weak self] user in
                self?.saveCognitoData(user: user)
            }).disposed(by: bag)
    }
    
    override var identityProviderName: String {
        return "cognito-identity.amazonaws.com"
    }
    
    override func token() -> AWSTask<NSString> {
        if AuthService.shared.isLoggedIn, let token = cognitoToken, let id = cognitoIdentityId {
            identityId = id
            return AWSTask(result: NSString(string: token))
        } else {
            return AWSTask(result: nil)
        }
    }
    
    override func logins() -> AWSTask<NSDictionary> {
        if AuthService.shared.isLoggedIn {
            return super.logins()
        } else {
            return AWSTask(result: nil)
        }
    }
    
    override func clear() {
        super.clear()
    }
    
    // MARK: User Defaults
    func saveCognitoData(user: User?) {
        cognitoToken = user?.cognitoToken
        cognitoIdentityId = user?.identityId
        UserDefaults.standard.synchronize()
    }
    
    private var cognitoToken: String? {
        get { return UserDefaults.standard.string(forKey: COGNITO_TOKEN_KEY) }
        set { UserDefaults.standard.set(newValue, forKey: COGNITO_TOKEN_KEY) }
    }
    
    private var cognitoIdentityId: String? {
        get { return UserDefaults.standard.string(forKey: COGNITO_IDENTITY_ID_KEY) }
        set { UserDefaults.standard.set(newValue, forKey: COGNITO_IDENTITY_ID_KEY) }
    }
}

