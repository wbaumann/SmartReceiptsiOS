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
    private(set) var selection = GenerateReportSelection()
    private var settingsTapSubject = PublishSubject<Void>()

    var onSettingsTap: Observable<Void> { return settingsTapSubject.asObservable() }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        
        form
        +++ Section()
        <<< ButtonRow() { row in
            row.title = LocalizedString("generate_report_tooltip")
        }.cellSetup({ cell, _ in
            cell.tintColor = AppTheme.primaryColor
        }).onCellSelection({ [weak self] _,_ in
            self?.settingsTapSubject.onNext(())
        })
            
        
        +++ Section()
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_PDF_FULL"))
        .onChange({ [weak self] row in
            self?.selection.fullPdfReport = row.value ?? false
        })
        
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_PDF_IMAGES"))
        .onChange({ [weak self] row in
            self?.selection.pdfReportWithoutTable = row.value ?? false
        })
    
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_CSV"))
        .onChange({ [weak self] row in
            self?.selection.csvFile = row.value ?? false
        })
            
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_ZIP"))
        .onChange({ [weak self] row in
            self?.selection.zipFiles = row.value ?? false
        })
    
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_ZIP_WITH_METADATA"))
        .onChange({ [weak self] row in
            self?.selection.zipStampedJPGs = row.value ?? false
        })
    }
    
    private func checkRow(title: String) -> CheckRow {
        return CheckRow() { row in
            row.title = LocalizedString(title)
        }.cellSetup({ cell, _ in
            cell.tintColor = AppTheme.primaryColor
        })
    }
}
