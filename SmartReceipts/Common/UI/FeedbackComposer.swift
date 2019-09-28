//
//  FeedbackComposer.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 31/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation
import MessageUI

class FeedbackComposer: NSObject, MFMailComposeViewControllerDelegate {
    weak var presentationViewController: UIViewController?
    
    func present(on viewController: UIViewController, subject: String, attachments: [FeedbackAttachment] = []) {
        presentationViewController = viewController
        
        if !MFMailComposeViewController.canSendMail() {
            Logger.warning("Mail services are not available.")
            
            let title = LocalizedString("generic_error_alert_title")
            let message = LocalizedString("error_email_not_configured_message")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
            
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
        
        let mailViewController = MFMailComposeViewController()
        
        // Attach log files
        Logger.logFiles()
            .map { ($0.fileName, try? Data(contentsOf: URL(fileURLWithPath: $0.filePath))) }
            .filter { $1 != nil }
            .map { FeedbackAttachment(data: $1!, mimeType: "text/plain", fileName: $0) }
            .adding(attachments)
            .forEach { mailViewController.addAttachment($0) }
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients([FeedbackEmailAddress])
        mailViewController.setSubject(subject)
        mailViewController.setMessageBody(messageBody, isHTML: false)
        mailViewController.navigationBar.tintColor = AppTheme.primaryColor
        mailViewController.view.tintColor = AppTheme.primaryColor
        
        viewController.present(mailViewController, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        guard result == .failed else {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        Logger.warning("MFMailComposeResultFailed: \(error!.localizedDescription)")
        let title = LocalizedString("generic_error_alert_title")
        let alert = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
        controller.dismiss(animated: true) { [weak self] in
            self?.presentationViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}

struct FeedbackAttachment {
    let data: Data
    let mimeType: String
    let fileName: String
}

extension MFMailComposeViewController {
    func addAttachment(_ attachment: FeedbackAttachment) {
        addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
    }
}
