//
//  AppNotificationCenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 23/07/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@objc class AppNotificationCenter: NSObject {
    private static let wifiSubject = PublishSubject<Bool>()
    private static let syncProviderSubject = PublishSubject<SyncProvider>()
    private static let didSyncBackupSubject = PublishSubject<Void>()
    
    // MARK: - Subscribe
    
    class var preferencesWiFiOnly: Observable<Bool> { return wifiSubject.asObservable() }
    class var syncProvider: Observable<SyncProvider> { return syncProviderSubject.asObservable() }
    class var didSyncBackup: Observable<Void> { return didSyncBackupSubject.asObservable() }
    
    // MARK: - Post
    
    @objc class func postWifiPreferencesUpdate(_ value: Bool) {
        AppNotificationCenter.wifiSubject.onNext(value)
    }
    
    class func postSyncProviderChanged(_ value: SyncProvider) {
        AppNotificationCenter.syncProviderSubject.onNext(value)
    }
    
    class func postDidSyncBackup() {
        AppNotificationCenter.didSyncBackupSubject.onNext(())
    }
}
