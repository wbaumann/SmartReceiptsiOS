//
//  GoogleDriveService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMAppAuth
import RxSwift

fileprivate let GOOGLE_CLIENT_ID = "718869294394-6p4ic33brhs8nd4rgvu72q76o5mfvft2.apps.googleusercontent.com"

class GoogleDriveService: NSObject, GIDSignInDelegate {
    static let shared = GoogleDriveService()
    
    private let gDriveService = GTLRDriveService()
    private var signInSubject = PublishSubject<Void>()
    private var signOutSubject = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    private override init() {
        gDriveService.shouldFetchNextPages = true
        gDriveService.isRetryEnabled = true
    }
    
    func initialize() {
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signIn(onUI viewController: GIDSignInUIDelegate) -> Observable<Void> {
        GIDSignIn.sharedInstance().uiDelegate = viewController
        GIDSignIn.sharedInstance().signIn()
        return signInSubject.asObserver()
    }
    
    func signOut() -> Observable<Void> {
        return signOutSubject.asObserver()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        gDriveService.authorizer = user.authentication.fetcherAuthorizer()
        signInSubject = PublishSubject<Void>()
        error != nil ? signInSubject.onError(error) : signInSubject.onNext()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        gDriveService.authorizer = nil
        signOutSubject = PublishSubject<Void>()
        error != nil ? signOutSubject.onError(error) : signOutSubject.onNext()
    }

}
