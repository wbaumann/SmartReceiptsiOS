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
    private static let wifiRelay = BehaviorRelay(value: WBPreferences.autobackupWifiOnly())
    private static let syncProviderRelay = BehaviorRelay(value: SyncProvider.current)
    private static let didSyncBackupSubject = PublishSubject<Void>()
    
    // MARK: - Subscribe
    
    class var preferencesWiFiOnly: Observable<Bool> { return wifiRelay.asObservable() }
    class var syncProvider: Observable<SyncProvider> { return syncProviderRelay.asObservable() }
    class var didSyncBackup: Observable<Void> { return didSyncBackupSubject.asObservable() }
    
    // MARK: - Post
    
    @objc class func postWifiPreferencesUpdate(_ value: Bool) {
        AppNotificationCenter.wifiRelay.accept(value)
    }
    
    class func postSyncProviderChanged(_ value: SyncProvider) {
        AppNotificationCenter.syncProviderRelay.accept(value)
    }
    
    class func postDidSyncBackup() {
        AppNotificationCenter.didSyncBackupSubject.onNext()
    }
}
