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
    
    // MARK: Generate report files
    
    func generate() {
        self.trackGeneratorEvents()
        
        let hud = PendingHUDView.showHUD(on: self.navigationController!.view)
        delayedExecution(0.3) {
            self.generator = ReportAssetsGenerator(trip: self.trip)
            self.generator!.setGenerated(self.fullPdfReportField.isOn, imagesPDF: self.pdfImagesField.isOn, csv: self.csvFileField.isOn, imagesZip: self.zipImagesField.isOn)
            
            self.generator!.generate(onSuccessHandler: { (files) in
                hud?.hide()
                
                // Creating the alert dialog:
                let sheet = UIAlertController(title: nil, message: NSLocalizedString("generate.report.share.method.sheet.title", comment: ""), preferredStyle: .alert)
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
                
            }, onErrorHandler: { (error) in
                hud?.hide()
                
                Logger.warning("ReportAssetsGenerator.generate() onError: \(error)")
                
                // Creating the error alert:
                let errorAlert = UIAlertController(title: NSLocalizedString("generate.report.unsuccessful.alert.message", comment: ""), message: "", preferredStyle: .alert)
                
                switch error {
                case .fullPdfFailed:
                    errorAlert.message = NSLocalizedString("generate.report.option.full.pdf", comment: "")
                case .fullPdfTooManyColumns:
                    errorAlert.title = NSLocalizedString("generate.report.unsuccessful.alert.pdf.columns.title", comment: "")
                    if WBPreferences.printReceiptTableLandscape() {
                        errorAlert.message = NSLocalizedString("generate.report.unsuccessful.alert.pdf.columns.message", comment: "")
                    } else {
                        errorAlert.message = NSLocalizedString("generate.report.unsuccessful.alert.pdf.columns.message.tryportrait", comment: "")
                    }
                    
                    let openSettingsAction = UIAlertAction(title: NSLocalizedString("generate.report.unsuccessful.alert.pdf.columns.gotosettings", comment: ""), style: .default) {
                        _ in
                        self.openSettingsAtSection()
                    }
                    errorAlert.addAction(openSettingsAction)
                    // generate.report.unsuccessful.alert.pdf.columns.gotosettings
                    
                case .imagesPdf:
                    errorAlert.message = NSLocalizedString("generate.report.option.pdf.no.table", comment: "")
                case .csvFailed:
                    errorAlert.message = NSLocalizedString("generate.report.option.csv", comment: "")
                case .zipImagesFailed:
                    errorAlert.message = NSLocalizedString("generate.report.option.zip.stamped", comment: "")
                }
                
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("generic.button.title.ok", comment: ""), style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            })
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
        present(composer, animated: true) {
            UIApplication.shared.setStatusBarStyle(barStyle, animated: false)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            Logger.error("Send email error: \(error)")
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
        let shareViewController = UIActivityViewController(activityItems: attached, applicationActivities: nil)
        shareViewController.completionWithItemsHandler = {
            type, success, returned, error in
            
            Logger.debug("Type \(type) - \(success)")
            Logger.debug("Returned \(returned?.count)")
            if let error = error {
                Logger.error(error.localizedDescription)
            }
            
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // For iPad
        if let popover = shareViewController.popoverPresentationController {
            popover.permittedArrowDirections = .up
            popover.sourceView = self.tableView
            popover.sourceRect = navigationController?.navigationBar.frame ?? self.view.frame
        }
        
        present(shareViewController, animated: true, completion: nil)
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
