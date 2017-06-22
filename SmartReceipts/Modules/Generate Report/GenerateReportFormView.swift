//
//  GenerateReportFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

class GenerateReportFormView: FormViewController {
    
    private weak var fullPdfReport: BehaviorSubject<Bool>!
    private weak var pdfReportWithoutTable: BehaviorSubject<Bool>!
    private weak var csvFile: BehaviorSubject<Bool>!
    private weak var zipStampedJPGs: BehaviorSubject<Bool>!
    weak var settingsTapObservable: PublishSubject<Void>?
    
    init(fullPdf: BehaviorSubject<Bool>, pdfNoTable: BehaviorSubject<Bool>,
         csvFile: BehaviorSubject<Bool>, zipStamped: BehaviorSubject<Bool>) {
        super.init(nibName: nil, bundle: nil)
        self.fullPdfReport = fullPdf
        self.pdfReportWithoutTable = pdfNoTable
        self.csvFile = csvFile
        self.zipStampedJPGs = zipStamped
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        
        form
        +++ Section()
        <<< ButtonRow() { row in
            row.title = LocalizedString("generate.report.button.configure.layout")
        }.cellSetup({ cell, _ in
            cell.tintColor = AppTheme.themeColor
        }).onCellSelection({ [weak self] _,_ in
            self?.settingsTapObservable?.onNext()
        })
        
        
        +++ Section()
        <<< checkRow(title: LocalizedString("generate.report.option.full.pdf"))
        .onChange({ [weak self] row in
            self?.fullPdfReport.onNext(row.value ?? false)
        })
        
        <<< checkRow(title: LocalizedString("generate.report.option.pdf.no.table"))
        .onChange({ [weak self] row in
            self?.pdfReportWithoutTable?.onNext(row.value ?? false)
        })
    
        <<< checkRow(title: LocalizedString("generate.report.option.csv"))
        .onChange({ [weak self] row in
            self?.csvFile.onNext(row.value ?? false)
        })
    
        <<< checkRow(title: LocalizedString("generate.report.option.zip.stamped"))
        .onChange({ [weak self] row in
            self?.zipStampedJPGs?.onNext(row.value ?? false)
        })
    }
    
    private func checkRow(title: String) -> CheckRow {
        return CheckRow() { row in
            row.title = LocalizedString(title)
        }.cellSetup({ cell, _ in
            cell.tintColor = AppTheme.themeColor
        })
    }
}
