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
        
        self.trackGeneratorEvents()
        
        let hud = PendingHUDView.showHUD(on: self.navigationController!.view)
        delayedExecution(0.3) {
            self.generator = ReportAssetsGenerator(trip: self.trip)

            self.generator!.setGenerated(self.fullPdfReportField.isOn, imagesPDF: self.pdfImagesField.isOn, csv: self.csvFileField.isOn, imagesZip: self.zipImagesField.isOn)
            
            self.generator!.generate() {
                files in
                
                hud?.hide()
                
                guard let files = files else {
                    self.presentAlert(NSLocalizedString("generic.error.alert.title", comment: ""), message: NSLocalizedString("generate.report.unsuccessful.alert.message", comment: ""))
                    return
                }
                
                let sheet = UIAlertController(title: nil, message: NSLocalizedString("generate.report.share.method.sheet.title", comment: ""), preferredStyle: .actionSheet)
                let emailAction = UIAlertAction(title: NSLocalizedString("generate.report.share.method.email", comment: ""), style: .default) {
                    _ in
                    
                    self.emailFiles(files)
                }
                let otherAction = UIAlertAction(title: NSLocalizedString("generate.report.share.method.other", comment: ""), style: .default) {
                    _ in
                    
                    self.shareFiles(files)
                }
                sheet.addAction(emailAction)
                sheet.addAction(otherAction)
                sheet.addAction(UIAlertAction(title: NSLocalizedString("generic.button.title.cancel", comment: ""), style: .cancel, handler: nil))
                self.present(sheet, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func split(_ string: String) -> [String] {
        return string.components(separatedBy: ",")
    }
}

extension WBGenerateViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    fileprivate func emailFiles(_ files: [String]) {
        guard MFMailComposeViewController.canSendMail() else {
            presentAlert(NSLocalizedString("generate.report.email.not.configured.title", comment: ""), message: NSLocalizedString("generate.report.email.not.configured.message", comment: ""))
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
            Log.debug("Attach \(file)")
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
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
        let barStyle = UIApplication.shared.statusBarStyle
        present(composer, animated: true) {
            UIApplication.shared.setStatusBarStyle(barStyle, animated: true)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            Log.error("Send email error: \(error)")
        }
        
        controller.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension WBGenerateViewController {
    fileprivate func shareFiles(_ files: [String]) {
        var attached = [URL]()
        for file in files {
            attached.append(URL(fileURLWithPath: file))
        }
        let controller = UIActivityViewController(activityItems: attached, applicationActivities: nil)
        controller.completionWithItemsHandler = {
            type, success, returned, error in
            
            Log.debug("Type \(type) - \(success)")
            Log.debug("Returned \(returned?.count)")
            Log.error(error)
            
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Analytics

extension WBGenerateViewController {
    
    func trackConfigureReportevent() {
        AnalyticsManager.sharedManager.record(event: Event.Informational.ConfigureReport)
    }
    
    func trackGeneratorEvents() {
        if fullPdfReportField.isOn {
            AnalyticsManager.sharedManager.record(event: Event.Generate.FullPdfReport)
        }
        if pdfImagesField.isOn {
            AnalyticsManager.sharedManager.record(event: Event.Generate.ImagesPdfReport)
        }
        if csvFileField.isOn {
            AnalyticsManager.sharedManager.record(event: Event.Generate.CsvReport)
        }
        if zipImagesField.isOn {
            AnalyticsManager.sharedManager.record(event: Event.Generate.StampedZipReport)
        }
    }
}
