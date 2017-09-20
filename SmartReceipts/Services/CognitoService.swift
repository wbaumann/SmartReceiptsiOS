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
    private let tokenVar = Variable<String>("")
    private let authService = AuthService()
    private let bag = DisposeBag()
    
    override init() {
        super.init(regionType: .USEast1, identityPoolId: "us-east-1:cdcc971a-b67f-4bc0-9a12-291b5d416518", useEnhancedFlow: true, identityProviderManager: nil)
        
        authService.token
            .bind(to: tokenVar)
            .disposed(by: bag)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityProvider:self)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    override func token() -> AWSTask<NSString> {
        self.identityId = tokenVar.value
        return AWSTask(result: NSString(string: tokenVar.value))
    }
}

