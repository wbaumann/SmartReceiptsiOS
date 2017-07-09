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

//MARK: - Public Interface Protocol
protocol SettingsViewInterface {
    var doneButton: UIBarButtonItem { get }
}

//MARK: SettingsView Class
final class SettingsView: UserInterface {
    
    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    
    private var formView: SettingsFormView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("settings.controller.title")
        
        formView = SettingsFormView(settingsView: self)
        formView.openModuleSubject = presenter.openModuleSubject
        formView.alertSubject = presenter.alertSubject
        
        addChildViewController(formView)
        view.addSubview(formView.view)
    }
}

//MARK: - Public interface
extension SettingsView: SettingsViewInterface {
    var doneButton: UIBarButtonItem { get{ return doneButtonItem } }
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

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsView {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
    var displayData: SettingsDisplayData {
        return _displayData as! SettingsDisplayData
    }
}
