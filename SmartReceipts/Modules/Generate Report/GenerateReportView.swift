//
//  GenerateReportView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxCocoa
import RxSwift

//MARK: - Public Interface Protocol
protocol GenerateReportViewInterface {
    func hideHud()
}

//MARK: GenerateReport View
final class GenerateReportView: UserInterface {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIButton!
    var hud: PendingHUDView?
    
    let settingsTapObservable = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    fileprivate var formView: GenerateReportFormView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formView = GenerateReportFormView(fullPdf: presenter.fullPdfReport,
                                       pdfNoTable: presenter.pdfReportWithoutTable,
                                          csvFile: presenter.csvFile,
                                       zipStamped: presenter.zipStampedJPGs)
        formView?.settingsTapObservable = settingsTapObservable
        
        addChildViewController(formView!)
        view.insertSubview(formView!.view, belowSubview: shareButton)
        configureUIActions()
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.presenter.close()
        }).disposed(by: disposeBag)
        
        shareButton.rx.tap.subscribe(onNext: { [weak self] in
            if let navView = self?.navigationController?.view {
                self?.hud = PendingHUDView.show(on: navView)
                self?.presenter.generateReport()
            }
        }).disposed(by: disposeBag)
        
        settingsTapObservable.subscribe { [weak self] _ in
            self?.presenter.presentSettings()
        }.disposed(by: disposeBag)
    }
}

//MARK: - Public interface
extension GenerateReportView: GenerateReportViewInterface {
    
    func hideHud() {
        hud?.hide()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportView {
    var presenter: GenerateReportPresenter {
        return _presenter as! GenerateReportPresenter
    }
    var displayData: GenerateReportDisplayData {
        return _displayData as! GenerateReportDisplayData
    }
}
