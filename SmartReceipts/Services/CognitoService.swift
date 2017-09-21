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
    private let identityIdVar = Variable<String>("")
    private let authService = AuthService()
    private let bag = DisposeBag()
    
    var credentialsProvider: AWSCognitoCredentialsProvider!
    
    override init() {
        super.init(regionType: .USEast1, identityPoolId: "us-east-1:cdcc971a-b67f-4bc0-9a12-291b5d416518", useEnhancedFlow: true, identityProviderManager: nil)
        
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityProvider:self)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        AuthService.loggedInObservable
            .filter({ $0 })
            .subscribe(onNext: { [unowned self] _ in
                self.logins().continueOnSuccessWith { task -> Any? in
                    if task.error != nil {
                        Logger.error(task.error!.localizedDescription)
                    } else if let id = task.result?[self.identityProviderName] as? String {
                        self.identityIdVar.value = id
                    }
                    return nil
                }
            }).disposed(by: bag)
    }
    
    var identityIdObservable: Observable<String> {
        return identityIdVar.asObservable().filter({ !$0.isEmpty })
    }
    
    override var identityProviderName: String {
        return "login.smartreceipts.co"
    }
    
    override func token() -> AWSTask<NSString> {
        if AuthService.isLoggedIn {
            identityId = authService.token
            return AWSTask(result: NSString(string: authService.token))
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
    }
}

