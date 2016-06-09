//
//  WBGenerateViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import MessageUI

extension WBGenerateViewController: QuickAlertPresenter {
    func generate() {
        let hud = PendingHUDView.showHUDOnView(self.navigationController!.view)
        delayedExecution(0.3) {
            self.generator = ReportAssetsGenerator(trip: self.trip)

            self.generator!.setGenerated(self.fullPdfReportField.on, imagesPDF: self.pdfImagesField.on, csv: self.csvFileField.on, imagesZip: self.zipImagesField.on)
            
            self.generator!.generate() {
                files in
                
                hud.hide()
                
                guard let files = files else {
                    self.presentAlert(NSLocalizedString("generic.error.alert.title", comment: ""), message: NSLocalizedString("generate.report.unsuccessful.alert.message", comment: ""))
                    return
                }
                
                let sheet = UIAlertController(title: nil, message: NSLocalizedString("generate.report.share.method.sheet.title", comment: ""), preferredStyle: .ActionSheet)
                let emailAction = UIAlertAction(title: NSLocalizedString("generate.report.share.method.email", comment: ""), style: .Default) {
                    _ in
                    
                    self.emailFiles(files)
                }
                let otherAction = UIAlertAction(title: NSLocalizedString("generate.report.share.method.other", comment: ""), style: .Default) {
                    _ in
                    
                    self.shareFiles(files)
                }
                sheet.addAction(emailAction)
                sheet.addAction(otherAction)
                sheet.addAction(UIAlertAction(title: NSLocalizedString("generic.button.title.cancel", comment: ""), style: .Cancel, handler: nil))
                self.presentViewController(sheet, animated: true, completion: nil)
            }
        }
    }
    
    private func split(string: String) -> [String] {
        return string.componentsSeparatedByString(",")
    }
}

extension WBGenerateViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    private func emailFiles(files: [String]) {
        guard MFMailComposeViewController.canSendMail() else {
            presentAlert(NSLocalizedString("generate.report.email.not.configured.title", comment: ""), message: NSLocalizedString("generate.report.email.not.configured.message", comment: ""))
            return
        }
        
        let suffix = files.count > 0 ? NSLocalizedString("generate.report.multiple.attached.suffix", comment: "") : NSLocalizedString("generate.report.one.attached.suffix", comment: "")
        let messageBody = "\(files.count) \(suffix)"
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject(WBPreferences.defaultEmailSubject().stringByReplacingOccurrencesOfString("%REPORT_NAME%", withString: trip.name))
        composer.setMessageBody(messageBody, isHTML: false)
        composer.setToRecipients(split(WBPreferences.defaultEmailRecipient()))
        composer.setCcRecipients(split(WBPreferences.defaultEmailCC()))
        composer.setBccRecipients(split(WBPreferences.defaultEmailBCC()))

        for file in files {
            Log.debug("Attach \(file)")
            guard let data = NSData(contentsOfFile: file) else {
                Log.debug("No data?")
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
        let barStyle = UIApplication.sharedApplication().statusBarStyle
        presentViewController(composer, animated: true) {
            UIApplication.sharedApplication().setStatusBarStyle(barStyle, animated: true)
        }
    }
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if let error = error {
            Log.error("Send email error: \(error)")
        }
        
        switch result {
        case MFMailComposeResultFailed, MFMailComposeResultCancelled:
            controller.dismissViewControllerAnimated(true, completion: nil)
        default:
            controller.dismissViewControllerAnimated(true) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

extension WBGenerateViewController {
    private func shareFiles(files: [String]) {
        var attached = [NSURL]()
        for file in files {
            attached.append(NSURL(fileURLWithPath: file))
        }
        let controller = UIActivityViewController(activityItems: attached, applicationActivities: nil)
        controller.completionWithItemsHandler = {
            type, success, returned, error in
            
            Log.debug("Type \(type) - \(success)")
            Log.debug("Returned \(returned?.count)")
            Log.error(error)
            
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
}