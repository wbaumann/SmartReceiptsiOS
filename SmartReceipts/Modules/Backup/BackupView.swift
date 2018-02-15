//
//  BackupView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol BackupViewInterface {
}

//MARK: BackupView Class
final class BackupView: UserInterface {
    fileprivate var documentInteractionController: UIDocumentInteractionController!
    
    @IBOutlet private weak var closeButton: UIBarButtonItem!
    @IBOutlet private weak var importButton: UIButton!
    @IBOutlet private weak var backupButton: UIButton!
    @IBOutlet private weak var manualBackupTitle: UILabel!
    @IBOutlet private weak var manualBackupDesctiption: UILabel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRx()
        configureLayers()
        localizeUI()
    }
    
    private func localizeUI() {
        title = LocalizedString("backups_view_title")
        manualBackupTitle.text = LocalizedString("backups_view_manual_title")
        manualBackupDesctiption.text = LocalizedString("backups_view_manual_description")
        importButton.setTitle(LocalizedString("backups_view_import_button").uppercased(), for: .normal)
        backupButton.setTitle(LocalizedString("backups_view_backup_button").uppercased(), for: .normal)
    }
    
    private func configureRx() {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
        
        backupButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showBackup(from: self.backupButton.frame)
            }).disposed(by: bag)
    }
    
    private func configureLayers() {
        let cornerRadius: CGFloat = 5
        
        importButton.layer.cornerRadius = cornerRadius
        backupButton.layer.cornerRadius = cornerRadius
    }
}

//MARK: - Public interface
extension BackupView: BackupViewInterface {
}

//MARK: Backup Files
extension BackupView {
    func showBackup(from: CGRect) {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.BackupOverflow)
        
        let exportAction: (UIAlertAction) -> Void = { [unowned self] action in
            let hud = PendingHUDView.show(on: self.navigationController!.view)
            let tick = TickTock.tick()
            DispatchQueue.global().async {
                let export = DataExport(workDirectory: FileManager.documentsPath)
                let exportPath = export.execute()
                let isFileExists = FileManager.default.fileExists(atPath: exportPath)
                Logger.info("Export finished: time \(tick.tock()), exportPath: \(exportPath)")
                
                DispatchQueue.main.async {
                    hud.hide()
                    if isFileExists {
                        var showRect = from
                        showRect.origin.y += self.view.frame.origin.y
                        
                        let fileUrl = URL(fileURLWithPath: exportPath)
                        Logger.info("shareBackupFile via UIDocumentInteractionController with url: \(fileUrl)")
                        let controller = UIDocumentInteractionController(url: fileUrl)
                        Logger.info("UIDocumentInteractionController UTI: \(controller.uti!)")
                        controller.presentOptionsMenu(from: showRect, in: self.view, animated: true)
                        self.documentInteractionController = controller
                    } else {
                        Logger.error("Failed to properly export data")
                        self.presenter._router.openAlert(title: LocalizedString("generic.error.alert.title"),
                                                       message: LocalizedString("settings.controller.export.error.message"))
                    }
                }
            }
        }
        
        let sheet = UIAlertController(title: LocalizedString("settings.export.confirmation.alert.title"),
                                      message: LocalizedString("settings.export.confirmation.alert.message"),
                                      preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: LocalizedString("settings.export.confirmation.export.button"),
                                      style: .default, handler: exportAction))
        present(sheet, animated: true, completion: nil)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupView {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
    var displayData: BackupDisplayData {
        return _displayData as! BackupDisplayData
    }
}
