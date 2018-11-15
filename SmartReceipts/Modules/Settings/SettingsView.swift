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
    
    private var formView: SettingsFormView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("menu_main_settings")
        
        formView = SettingsFormView(settingsView: self)
        formView.showOption = displayData.showSettingsOption
        formView.openModuleSubject = presenter.openModuleSubject
        formView.alertSubject = presenter.alertSubject
        
        addChild(formView)
        view.addSubview(formView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return presenter.retrivePlusSubscriptionPrice()
    }
    
    func restoreSubscription() -> Observable<SubscriptionValidation> {
        return presenter.restoreSubscription()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return presenter.purchaseSubscription()
    }
    
    func subscriptionValidation() -> Observable<SubscriptionValidation> {
        return presenter.subscriptionValidation()
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
        if !MFMailComposeViewController.canSendMail() {
            Logger.warning("Mail services are not available.")
            presenter.alertSubject
                .onNext((title: LocalizedString("generic_error_alert_title"),
                       message: LocalizedString("error_email_not_configured_message")))
            return
        }
        
        // Configure the fields of the interface.
        var messageBody = ""
        // attach device info metadata
        messageBody += "\n\n\nDebug info:\n"
        messageBody += UIApplication.shared.appVersionInfoString()
        messageBody += "Plus: \(PurchaseService.hasValidSubscriptionValue ? "true" : "false")\n"
        messageBody += "\(UIDevice.current.deviceInfoString()!)\n"
        messageBody += "Locale: \(Locale.current.identifier)"
        
        let composeVC = MFMailComposeViewController()
        
        // Attach log files
        Logger.logFiles()
            .map { ($0.fileName, try? Data(contentsOf: URL(fileURLWithPath: $0.filePath))) }
            .filter { $1 != nil }
            .forEach { composeVC.addAttachmentData($1!, mimeType: "text/plain", fileName: $0) }
        
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([FeedbackEmailAddress])
        composeVC.setSubject(subject)
        composeVC.setMessageBody(messageBody, isHTML: false)
        composeVC.navigationBar.tintColor = .white
        
        present(composeVC, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .failed {
            Logger.warning("MFMailComposeResultFailed: \(error!.localizedDescription)")
            presenter.alertSubject.onNext((title: LocalizedString("generic_error_alert_title"),
                                         message: error!.localizedDescription))
        }
        dismiss(animated: true, completion: nil)
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
