//
//  GenerateReportInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa

class GenerateReportInteractor: Interactor {
    private let disposeBag = DisposeBag()
    
    var generator: ReportAssetsGenerator?
    var shareService: GenerateReportShareService?
    
    private var fullPdfReport: Variable         = Variable(false)
    private var pdfReportWithoutTable: Variable = Variable(false)
    private var csvFile: Variable               = Variable(false)
    private var zipStampedJPGs: Variable        = Variable(false)
    
    func configureBinding() {
        presenter.fullPdfReport.bind(to: fullPdfReport).addDisposableTo(disposeBag)
        presenter.pdfReportWithoutTable.bind(to: pdfReportWithoutTable).addDisposableTo(disposeBag)
        presenter.csvFile.bind(to: csvFile).addDisposableTo(disposeBag)
        presenter.zipStampedJPGs.bind(to: zipStampedJPGs).addDisposableTo(disposeBag)
    }
    
    func trackConfigureReportEvent() {
        AnalyticsManager.sharedManager.record(event: Event.Informational.ConfigureReport)
    }
    
    func trackGeneratorEvents() {
        if fullPdfReport.value {
            AnalyticsManager.sharedManager.record(event: Event.Generate.FullPdfReport)
        }
        if pdfReportWithoutTable.value {
            AnalyticsManager.sharedManager.record(event: Event.Generate.ImagesPdfReport)
        }
        if csvFile.value {
            AnalyticsManager.sharedManager.record(event: Event.Generate.CsvReport)
        }
        if zipStampedJPGs.value {
            AnalyticsManager.sharedManager.record(event: Event.Generate.StampedZipReport)
        }
    }
    
    func generateReport() {
        if !validateSelection() { return }
        
        delayedExecution(0.3) {
            
            self.generator?.setGenerated(self.fullPdfReport.value, imagesPDF: self.pdfReportWithoutTable.value,
                                          csv: self.csvFile.value, imagesZip: self.zipStampedJPGs.value)
            
            self.generator!.generate(onSuccessHandler: { (files) in
                self.presenter.hideHudFromView()
                
                var actions = [UIAlertAction]()
                let message = LocalizedString("generate.report.share.method.sheet.title")
                let emailAction = UIAlertAction(title: LocalizedString("generate.report.share.method.email"), style: .default) {
                    _ in
                    self.shareService?.emailFiles(files)
                }
                let otherAction = UIAlertAction(title: LocalizedString("generate.report.share.method.other"), style: .default) {
                    _ in
                    self.shareService?.shareFiles(files)
                }
                
                actions.append(emailAction)
                actions.append(otherAction)
                actions.append(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: nil))
                
                self.presenter.presentSheet(title: nil, message: message, actions: actions)
                
            }, onErrorHandler: { (error) in
                self.presenter.hideHudFromView()
                
                Logger.warning("ReportAssetsGenerator.generate() onError: \(error)")
                
                var actions = [UIAlertAction]()
                var title = LocalizedString("generate.report.unsuccessful.alert.message")
                var message = ""
                
                switch error {
                case .fullPdfFailed:
                    message = LocalizedString("generate.report.option.full.pdf")
                case .fullPdfTooManyColumns:
                    title = LocalizedString("generate.report.unsuccessful.alert.pdf.columns.title")
                    if WBPreferences.printReceiptTableLandscape() {
                        message = LocalizedString("generate.report.unsuccessful.alert.pdf.columns.message")
                    } else {
                        message = LocalizedString("generate.report.unsuccessful.alert.pdf.columns.message.tryportrait")
                    }
                    
                    let openSettingsAction = UIAlertAction(title: LocalizedString("generate.report.unsuccessful.alert.pdf.columns.gotosettings"),
                                                           style: .default, handler: { _ in
                        self.presenter.presentSettings()
                    })
                    actions.append(openSettingsAction)
                    
                case .imagesPdf:
                    message = LocalizedString("generate.report.option.pdf.no.table")
                case .csvFailed:
                    message = LocalizedString("generate.report.option.csv")
                case .zipImagesFailed:
                    message = LocalizedString("generate.report.option.zip.stamped")
                }
                actions.append(UIAlertAction(title: LocalizedString("generic.button.title.ok"), style: .default, handler: nil))
                self.presenter.presentSheet(title: title, message: message, actions: actions)
            })
        }
    }
    
    func validateSelection() -> Bool {
        if (!fullPdfReport.value && !pdfReportWithoutTable.value && !csvFile.value && !zipStampedJPGs.value) {
            presenter.presentAlert(title: LocalizedString("generic.error.alert.title"),
                                   message: LocalizedString("generate.report.no.options.selected.alert.message"))
            return false
        }
        return true
    }
    
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportInteractor {
    var presenter: GenerateReportPresenter {
        return _presenter as! GenerateReportPresenter
    }
}
