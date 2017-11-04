//
//  SettingsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import MessageUI
import StoreKit

//MARK: - Public Interface Protocol
protocol SettingsViewInterface {
    var doneButton: UIBarButtonItem { get }
    func setupShowSettingsOption(_ option: ShowSettingsOption?)
}

//MARK: SettingsView Class
final class SettingsView: UserInterface {
    
    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    fileprivate var documentInteractionController: UIDocumentInteractionController!
    
    private var formView: SettingsFormView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("settings.controller.title")
        
        formView = SettingsFormView(settingsView: self)
        formView.showOption = displayData.showSettingsOption
        formView.openModuleSubject = presenter.openModuleSubject
        formView.alertSubject = presenter.alertSubject
        
        addChildViewController(formView)
        view.addSubview(formView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return presenter.retrivePlusSubscriptionPrice()
    }
    
    func restorePurchases() -> Observable<Void> {
        return presenter.restorePurchases()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return presenter.purchaseSubscription()
    }
}

//MARK: - Public interface
extension SettingsView: SettingsViewInterface {
    var doneButton: UIBarButtonItem { get{ return doneButtonItem } }
    
    func setupShowSettingsOption(_ option: ShowSettingsOption?) {
        displayData.showSettingsOption = option
    }
}

//MARK: Email Composer
extension SettingsView: MFMailComposeViewControllerDelegate {
    
    func sendFeedback(subject: String) {
        if (!MFMailComposeViewController.canSendMail()) {
            Logger.warning("Mail services are not available.")
            presenter.alertSubject
                .onNext((title: LocalizedString("settings.feedback.email.error"),
                       message: LocalizedString("settings.feedback.email.not.configured.message")))
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        var messageBody = ""
        // attach device info metadata
        messageBody += "\n\n\nDebug info:\n"
        messageBody += UIApplication.shared.appVersionInfoString()
        messageBody += "Plus: \(Database.sharedInstance().hasValidSubscription() ? "true" : "false")\n"
        messageBody += UIDevice.current.deviceInfoString()
        
        // Attach log files
        let logFiles = Logger.logFiles()
        for file in logFiles {
            let data = NSData(contentsOfFile: file.filePath)
            if data != nil {
                composeVC .addAttachmentData(data! as Data, mimeType: "text/plain", fileName: file.fileName)
            }
        }
        
        composeVC.setToRecipients([FeedbackEmailAddress])
        composeVC.setSubject(subject)
        composeVC.setMessageBody(messageBody, isHTML: false)
        composeVC.navigationBar.tintColor = UINavigationBar.appearance().tintColor
        
        let style = UIApplication.shared.statusBarStyle
        present(composeVC, animated: true) { 
            UIApplication.shared.setStatusBarStyle(style, animated: false)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
         didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .failed {
            Logger.warning("MFMailComposeResultFailed: \(error!.localizedDescription)")
            presenter.alertSubject.onNext((title: LocalizedString("settings.feedback.email.error"),
                                         message: error!.localizedDescription))
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Backup Files
extension SettingsView {
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
                        self.presenter.alertSubject
                            .onNext((title: LocalizedString("generic.error.alert.title"),
                                   message: LocalizedString("settings.controller.export.error.message")))
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
private extension SettingsView {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
    var displayData: SettingsDisplayData {
        return _displayData as! SettingsDisplayData
    }
}
