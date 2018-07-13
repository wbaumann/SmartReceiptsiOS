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
import Toaster

class GenerateReportInteractor: Interactor {
    var generator: ReportAssetsGenerator?
    var shareService: GenerateReportShareService?
    var trip: WBTrip!
    
    private var fullPdfReport: BehaviorRelay         = BehaviorRelay(value: false)
    private var pdfReportWithoutTable: BehaviorRelay = BehaviorRelay(value: false)
    private var csvFile: BehaviorRelay               = BehaviorRelay(value: false)
    private var zipStampedJPGs: BehaviorRelay        = BehaviorRelay(value: false)
    
    private let bag = DisposeBag()
    
    var titleSubtitle: TitleSubtitle {
        return (trip.name, trip.formattedPrice())
    }
    
    func configure(with trip: WBTrip) {
        self.trip = trip
        generator = ReportAssetsGenerator(trip: trip)
        shareService = GenerateReportShareService(presenter: presenter, trip: trip)
    }
    
    func configureBinding() {
        presenter.fullPdfReport.bind(to: fullPdfReport).disposed(by: bag)
        presenter.pdfReportWithoutTable.bind(to: pdfReportWithoutTable).disposed(by: bag)
        presenter.csvFile.bind(to: csvFile).disposed(by: bag)
        presenter.zipStampedJPGs.bind(to: zipStampedJPGs).disposed(by: bag)
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
        if needEnableDistance() {
            Logger.debug("Empty Receipts and disabled Include Distances. Go to Settings")
            AnalyticsManager.sharedManager.record(event: Event.Generate.NothingToGenerateCSV)
            
            Toast.show(LocalizedString("generate_report_toast_csv_report_distances"))
            presenter.hideHudFromView()
            presenter.presentEnableDistances()
            return
        }
        
        if !validateSelection() {
            presenter.hideHudFromView()
            return
        }
        
        delayedExecution(DEFAULT_ANIMATION_DURATION) {
            
            self.generator?.setGenerated(self.fullPdfReport.value, imagesPDF: self.pdfReportWithoutTable.value,
                                          csv: self.csvFile.value, imagesZip: self.zipStampedJPGs.value)
            
            self.generator!.generate(onSuccessHandler: { (files) in
                TooltipService.shared.markReportGenerated()
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
                actions.append(UIAlertAction(title: LocalizedString("generic.button.title.cancel"), style: .cancel, handler: {
                    _ in
                    for file in files { FileManager.deleteIfExists(filepath: file) }
                }))
                
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
                        self.presenter.presentOutputSettings()
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
    
    private func needEnableDistance() -> Bool {
        return csvFile.value && !WBPreferences.printDistanceTable() && Database.sharedInstance().allReceipts(for: trip).isEmpty
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportInteractor {
    var presenter: GenerateReportPresenter {
        return _presenter as! GenerateReportPresenter
    }
}
