//
//  BackupView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa
import GoogleSignIn

//MARK: - Public Interface Protocol
protocol BackupViewInterface  {
    var importTap: Observable<Void> { get }
    var signInUIDelegate: GIDSignInUIDelegate { get }
    func updateUI()
}

//MARK: BackupView Class
final class BackupView: UserInterface, GIDSignInUIDelegate {
    fileprivate var documentInteractionController: UIDocumentInteractionController!
    
    @IBOutlet private weak var closeButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var importButton: UIButton!
    @IBOutlet private weak var backupButton: UIButton!
    @IBOutlet private weak var manualBackupTitle: UILabel!
    @IBOutlet private weak var manualBackupDesctiption: UILabel!
    @IBOutlet private weak var configureButton: UIButton!
    @IBOutlet private weak var autoBackupTitle: UILabel!
    @IBOutlet private weak var autoBackupDesctiption: UILabel!
    @IBOutlet private weak var wifiLabel: UILabel!
    @IBOutlet private weak var wifiSwitch: UISwitch!
    @IBOutlet private weak var wifiView: UIView!
    @IBOutlet private weak var backupsView: UIStackView!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiSwitch.isOn = WBPreferences.autobackupWifiOnly()
        configureRx()
        configureLayers()
        localizeUI()
        updateUI()
    }
    
    private func localizeUI() {
        title = LocalizedString("backups_view_title")
        
        manualBackupTitle.text = LocalizedString("backups_view_manual_title")
        manualBackupDesctiption.text = LocalizedString("backups_view_manual_description")
        importButton.setTitle(LocalizedString("backups_view_import_button").uppercased(), for: .normal)
        backupButton.setTitle(LocalizedString("backups_view_backup_button").uppercased(), for: .normal)
        
        autoBackupTitle.text = LocalizedString("auto_backup_title")
        wifiLabel.text = LocalizedString("auto_backup_wifi_only")
    }
    
    func updateUI() {
        wifiView.isHidden = !presenter.hasValidSubscription() || SyncProvider.current == .none
        if SyncProvider.current == .googleDrive && presenter.hasValidSubscription() {
            autoBackupDesctiption.text = LocalizedString("auto_backup_warning_drive")
            configureButton.setTitle(SyncProvider.current.localizedTitle().uppercased(), for: .normal)
            configureButton.setImage(#imageLiteral(resourceName: "cloud-check"), for: .normal)
        } else {
            autoBackupDesctiption.text = LocalizedString("auto_backup_warning_none")
            configureButton.setTitle(LocalizedString("auto_backup_configure").uppercased(), for: .normal)
            configureButton.setImage(#imageLiteral(resourceName: "cloud-off"), for: .normal)
        }
    }
    
    private func configureRx() {
        presenter.getBackups()
            .subscribe(onSuccess: { [unowned self] backups in
                if backups.count == 0 { Logger.debug("No backups") }
                for backup in backups {
                    guard let backupItem = BackupItemView.loadInstance() else { continue }
                    backupItem.setup(backup: backup)
                    self.backupsView.addArrangedSubview(backupItem)
                    backupItem.onMenuTap().subscribe(onNext: { [weak self] in
                        self?.openActions(for: backup, item: backupItem)
                    }).disposed(by: self.bag)
                }
            }, onError: { error in
                Logger.error(error.localizedDescription)
            }).disposed(by: bag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
        
        backupButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showBackup(from: self.backupButton.frame)
            }).disposed(by: bag)
        
        configureButton.rx.tap
            .filter({ [unowned self] in self.presenter.hasValidSubscription() })
            .subscribe(onNext: { [unowned self] in
                self.openBackupServiceSelector()
            }).disposed(by: bag)
        
        configureButton.rx.tap
            .filter({ [unowned self] in !self.presenter.hasValidSubscription() })
            .flatMap({ [unowned self] in return self.presenter.purchaseSubscription() })
            .subscribe(onNext: { [unowned self] in
                self.openBackupServiceSelector()
            }).disposed(by: bag)
        
        wifiSwitch.rx.isOn
            .skip(1)
            .subscribe(onNext: { [unowned self] in
                self.presenter.setupUseWifiOnly(enabled: $0)
            }).disposed(by: bag)
    }
    
    private func openActions(for backup: RemoteBackupMetadata, item: BackupItemView?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LocalizedString("remote_backups_list_item_menu_restore"), style: .default, handler: { [unowned self] _ in
            self.openImport(backup: backup)
        }))
        alert.addAction(UIAlertAction(title: LocalizedString("remote_backups_list_item_menu_download_images"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizedString("remote_backups_list_item_menu_download_images_debug"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizedString("remote_backups_list_item_menu_delete"), style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func openImport(backup: RemoteBackupMetadata) {
        let title = String(format: LocalizedString("import_string_item"), backup.syncDeviceName)
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LocalizedString("import_string"), style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: LocalizedString("dialog_import_text"), style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: { _ in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func providerSelected(provider: SyncProvider) {
        presenter.saveCurrent(provider: provider)
    }
    
    private func openBackupServiceSelector() {
        let selector = makeBackupServiceSelector()
        present(selector, animated: true, completion: nil)
    }
    
    private func configureLayers() {
        let cornerRadius: CGFloat = 5
        
        importButton.layer.cornerRadius = cornerRadius
        backupButton.layer.cornerRadius = cornerRadius
    }
}

//MARK: - Public interface
extension BackupView: BackupViewInterface {
    var importTap: Observable<Void> { return importButton.rx.tap.asObservable() }
    var signInUIDelegate: GIDSignInUIDelegate { return self }
}

//MARK: AutoBackup Selector
extension BackupView {
    fileprivate func makeBackupServiceSelector() -> UIAlertController {
        
        func makeProviderAction(syncProvider: SyncProvider) -> UIAlertAction {
            return UIAlertAction(title: syncProvider.localizedTitle(), style: .default, handler: { [weak self] _ in
                self?.providerSelected(provider: syncProvider)
            })
        }
        
        let currentService = "\(LocalizedString("auto_backup_current_service")) - \(SyncProvider.current.localizedTitle())"
        let alert = UIAlertController(title: currentService, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: nil))
        alert.addAction(makeProviderAction(syncProvider:.googleDrive))
        alert.addAction(makeProviderAction(syncProvider: .none))
        return alert
    }
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
