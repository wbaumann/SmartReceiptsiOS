//
//  TripsDisplayData.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

fileprivate typealias MenuItem = (title: String, subject: PublishSubject<Void>)

final class TripsDisplayData: DisplayData {
    private let settingsSubject = PublishSubject<Void>()
    private let autoScansSubject = PublishSubject<Void>()
    private let backupSubject = PublishSubject<Void>()
    private let userGuideSubject = PublishSubject<Void>()
    
    var settingsTap: Observable<Void> { return settingsSubject.asObservable() }
    var autoScansTap: Observable<Void> { return autoScansSubject.asObservable() }
    var backupTap: Observable<Void> { return backupSubject.asObservable() }
    var userGuideTap: Observable<Void> { return userGuideSubject.asObservable() }
    
    func makeActions() -> [UIAlertAction] {
        let settingsAction = UIAlertAction(title: LocalizedString("menu_main_settings"),
            style: .default, handler: { _ in self.settingsSubject.onNext(()) })
        
        let ocrSettingsAction = UIAlertAction(title: LocalizedString("ocr_configuration_title"),
            style: .default, handler: { _ in self.autoScansSubject.onNext(()) })
        
        let backupAction = UIAlertAction(title: LocalizedString("backups"),
            style: .default, handler: { _ in self.backupSubject.onNext(()) })
        
        let userGuideAction = UIAlertAction(title: LocalizedString("menu_main_usage_guide"),
            style: .default, handler: { _ in self.userGuideSubject.onNext(()) })
        
        return [settingsAction, ocrSettingsAction, backupAction, userGuideAction]
    }
    
}
