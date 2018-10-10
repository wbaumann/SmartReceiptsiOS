//
//  TripsDisplayData.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import MKDropdownMenu
import RxSwift

fileprivate typealias MenuItem = (title: String, subject: PublishSubject<Void>)

final class TripsDisplayData: DisplayData {
    private let settingsSubject = PublishSubject<Void>()
    private let autoScansSubject = PublishSubject<Void>()
    private let backupSubject = PublishSubject<Void>()
    
    private(set) var menuDisplayData: TripsMenuDisplayData!
    
    var settingsTap: Observable<Void> { return settingsSubject.asObservable() }
    var autoScansTap: Observable<Void> { return autoScansSubject.asObservable() }
    var backupTap: Observable<Void> { return backupSubject.asObservable() }
    
    required init() {
        let items: [MenuItem]  = [
            (LocalizedString("menu_main_settings"), settingsSubject),
            (LocalizedString("ocr_configuration_title"), autoScansSubject),
            (LocalizedString("backups"), backupSubject)
        ]
        menuDisplayData = TripsMenuDisplayData(items: items)
    }
    
    func makeActions() -> [UIAlertAction] {
        let settingsAction = UIAlertAction(title: LocalizedString("menu_main_settings"),
            style: .default, handler: { _ in self.settingsSubject.onNext(()) })
        
        let ocrSettingsAction = UIAlertAction(title: LocalizedString("ocr_configuration_title"),
            style: .default, handler: { _ in self.autoScansSubject.onNext(()) })
        
        let backupAction = UIAlertAction(title: LocalizedString("backups"),
            style: .default, handler: { _ in self.backupSubject.onNext(()) })
        
        return [settingsAction, ocrSettingsAction, backupAction]
    }
    
}

// MENU
class TripsMenuDisplayData: NSObject, MKDropdownMenuDelegate, MKDropdownMenuDataSource  {
    private var items = [MenuItem]()
    
    fileprivate init(items: [MenuItem]) {
        self.items = items
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: items[row].title, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: AppTheme.primaryColor
        ])
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        items[row].subject.onNext(())
        dropdownMenu.closeAllComponents(animated: true)
    }
}
