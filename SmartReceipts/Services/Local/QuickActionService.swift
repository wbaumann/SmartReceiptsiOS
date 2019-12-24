//
//  QuickActionService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 26/12/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift

enum QuickAction: String {
    case camera
    case text
    case `import`
}

class QuickActionService {
    private let bag = DisposeBag()
    private var subscription: Disposable?
    private weak var view: UIViewController!
    private let scanService = ScanService()
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func configureQuickActions() {
        UIApplication.shared.shortcutItems = WBPreferences.lastOpenedTrip == nil ?
            [] : [.init(action: .camera), .init(action: .text), .init(action: .import)]
    }
    
    func performAction(action: QuickAction) {
        if WBPreferences.lastOpenedTrip == nil { return }
        
        switch action {
        case .camera: openCreatePhotoReceipt()
        case .text: openCreateTextReceipt()
        case .import: openImportReceiptFile()
        }
    }
    
    private func openCreatePhotoReceipt() {
        var hud: PendingHUDView?
        subscription = ImagePicker.shared.presentCamera(on: view)
            .flatMap({ [unowned self] img -> Single<ScanResult> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.scanService.status)
                return self.scanService.scan(image: img)
            }).subscribe(onSuccess: { [unowned self] scan in
                hud?.hide()
                self.openEditModule(with: scan)
            })
    }
    
    private func openImportReceiptFile() {
        var hud: PendingHUDView?
        ReceiptFilePicker.sharedInstance.openFilePicker(on: view)
            .do(onError: { [unowned self] error in
                Logger.error("Import failed with: \(error.localizedDescription)")
                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
                self.view.present(alert, animated: true, completion: nil)
            }).subscribe(onNext: { [unowned self] doc in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.scanService.status)
                self.subscription = self.scanService.scan(document: doc)
                    .subscribe(onSuccess: { [unowned self] scan in
                        hud?.hide()
                        self.openEditModule(with: scan)
                    })
            }, onError: { [unowned self] _ in
                self.openCreateTextReceipt()
            }).disposed(by: bag)
    }
    
    private func openCreateTextReceipt() {
        let receipt: WBReceipt? = nil
        let data = (trip: WBPreferences.lastOpenedTrip, receipt: receipt)
        openEditModuleWith(data: data)
    }
    
    private func openEditModuleWith(data: Any?) {
        subscription?.dispose()
        subscription = nil
        
        let module = AppModules.editReceipt.build()
        module.router.show(from: view, embedInNavController: true, setupData: data)
    }
    
    private func openEditModule(with scan: ScanResult) {
        let data = (trip: WBPreferences.lastOpenedTrip, scan: scan)
        openEditModuleWith(data: data)
    }
}

fileprivate extension UIApplicationShortcutItem {
    convenience init(action: QuickAction) {
        switch action {
        case .camera: self.init(type: action.rawValue, title: LocalizedString("receipt_action_camera"), icon: "camera")
        case .text: self.init(type: action.rawValue, title: LocalizedString("receipt_action_text"), icon: "file-text")
        case .import: self.init(type: action.rawValue, title: LocalizedString("receipt_action_import"), icon: "file-plus")
        }
    }
    
    convenience init(type: String, title: String, icon: String) {
        let icon = UIApplicationShortcutIcon(templateImageName: icon)
        self.init(type: type, localizedTitle: title, localizedSubtitle: nil, icon: icon, userInfo: nil)
    }
}
