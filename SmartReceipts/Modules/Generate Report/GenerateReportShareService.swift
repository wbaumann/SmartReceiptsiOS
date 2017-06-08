//
//  GenerateReportShareService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class GenerateReportShareService: NSObject, MFMailComposeViewControllerDelegate {

    private weak var presenter: GenerateReportPresenter!
    private var trip: WBTrip!
    
    init(presenter: GenerateReportPresenter, trip: WBTrip) {
        super.init()
        self.presenter = presenter
        self.trip = trip
    }
    
    func emailFiles(_ files: [String]) {
        guard MFMailComposeViewController.canSendMail() else {
            self.presenter.presentAlert(title: LocalizedString("generate.report.email.not.configured.title"),
                                        message: LocalizedString("generate.report.email.not.configured.message"))
            return
        }
        
        let suffix = files.count > 0 ? NSLocalizedString("generate.report.multiple.attached.suffix", comment: "") : NSLocalizedString("generate.report.one.attached.suffix", comment: "")
        let messageBody = "\(files.count) \(suffix)"
        
        let composer = MFMailComposeViewController()
        let subjectFormatter = SmartReceiptsFormattableString(fromOriginalText: WBPreferences.defaultEmailSubject())
        
        composer.mailComposeDelegate = self
        composer.setSubject(subjectFormatter.format(trip))
        composer.setMessageBody(messageBody, isHTML: false)
        composer.setToRecipients(split(WBPreferences.defaultEmailRecipient()))
        composer.setCcRecipients(split(WBPreferences.defaultEmailCC()))
        composer.setBccRecipients(split(WBPreferences.defaultEmailBCC()))
        
        for file in files {
            Logger.debug("func emailFiles: Attach \(file)")
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
                Logger.warning("func emailFiles: No data?")
                continue
            }
            
            let mimeType: String
            if file.hasSuffix("pdf") {
                mimeType = "application/pdf"
            } else if file.hasSuffix("csv") {
                mimeType = "text/csv"
            } else {
                mimeType = "application/octet-stream"
            }
            
            composer.addAttachmentData(data, mimeType: mimeType, fileName: NSString(string: file).lastPathComponent)
        }
        
        composer.navigationBar.tintColor = UINavigationBar.appearance().tintColor
        let barStyle = UIApplication.shared.statusBarStyle
        presenter.present(vc: composer, animated: true) {
            UIApplication.shared.setStatusBarStyle(barStyle, animated: false)
        }
    }
    
    func shareFiles(_ files: [String]) {
        var attached = [URL]()
        for file in files {
            attached.append(URL(fileURLWithPath: file))
        }
        let shareViewController = UIActivityViewController(activityItems: attached, applicationActivities: nil)
        shareViewController.completionWithItemsHandler = {
            type, success, returned, error in
            
            Logger.debug("Type \(type) - \(success)")
            Logger.debug("Returned \(returned?.count)")
            if let error = error {
                Logger.error(error.localizedDescription)
            }
            
            if success {
                self.presenter.close()
            }
        }
        presenter.present(vc: shareViewController, animated: true, isPopover: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            Logger.error("Send email error: \(error)")
        }
        
        controller.dismiss(animated: true) {
            self.presenter.close()
        }
    }
    
    fileprivate func split(_ string: String) -> [String] {
        return string.components(separatedBy: ",")
    }
}
