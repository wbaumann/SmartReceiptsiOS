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
    private let bag = DisposeBag()
    private(set) var selection = GenerateReportSelection()
    private var settingsTapSubject = PublishSubject<Void>()

    var onSettingsTap: Observable<Void> { return settingsTapSubject.asObservable() }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 74
        tableView.separatorInset = .zero
        
        let header = GenerateReportHeaderView.loadInstance()
        tableView.tableHeaderView = header
        
        header?.configureButton.rx.tap
            .bind(to: settingsTapSubject)
            .disposed(by: bag)
        
        form
        +++ Section()
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_PDF_FULL"), image: #imageLiteral(resourceName: "generate_pdf"), onChange: { [weak self] selected in
            self?.selection.fullPdfReport = selected
        })
        
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_PDF_IMAGES"), image: #imageLiteral(resourceName: "generate_pdf"), onChange: { [weak self] selected in
            self?.selection.pdfReportWithoutTable = selected
        })
    
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_CSV"), image: #imageLiteral(resourceName: "generate_csv"), onChange: { [weak self] selected in
            self?.selection.csvFile = selected
        })
            
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_ZIP"), image: #imageLiteral(resourceName: "generate_zip"), onChange: { [weak self] selected in
            self?.selection.zipFiles = selected
        })
    
        <<< checkRow(title: LocalizedString("DIALOG_EMAIL_CHECKBOX_ZIP_WITH_METADATA"), image: #imageLiteral(resourceName: "generate_zip"), onChange: { [weak self] selected in
            self?.selection.zipStampedJPGs = selected
        })
    }
    
    private func checkRow(title: String, image: UIImage?, onChange: @escaping (Bool)->Void) -> CheckRow {
        return CheckRow() { row in
            row.title = LocalizedString(title)
        }.cellSetup({ cell, _ in
            cell.imageView?.image = image?.withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = UIColor.black.withAlphaComponent(0.3)
            cell.tintColor = AppTheme.primaryColor
            cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "checkbox_unselected"))
            cell.textLabel?.font = .medium15
        }).onChange { row in
            let selected = row.value == true
            row.cell.imageView?.image = image?.withRenderingMode(.alwaysTemplate)
            row.cell.imageView?.tintColor = selected ? .srViolet : UIColor.black.withAlphaComponent(0.3)
            row.cell.backgroundColor = selected ? #colorLiteral(red: 0.8980392157, green: 0.8941176471, blue: 0.9215686275, alpha: 1) : .white
            
            onChange(selected)
            row.cell.accessoryView = selected ? UIImageView(image: #imageLiteral(resourceName: "checkbox_selected")) : UIImageView(image: #imageLiteral(resourceName: "checkbox_unselected"))
        }
    }
}
