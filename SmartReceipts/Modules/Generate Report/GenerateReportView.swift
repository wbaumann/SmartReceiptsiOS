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
    private var formView: GenerateReportFormView?
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIButton!
    var hud: PendingHUDView?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formView = GenerateReportFormView()
        
        addChild(formView!)
        view.insertSubview(formView!.view, belowSubview: shareButton)
        configureUIActions()
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.presenter.close()
        }).disposed(by: bag)
        
        shareButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let navView = self?.navigationController?.view, let selection = self?.formView?.selection else { return }
            self?.hud = PendingHUDView.show(on: navView)
            self?.presenter.generateReport(selection: selection)
        }).disposed(by: bag)
        
        formView?.onSettingsTap.subscribe(onNext: { [weak self] _ in
            self?.presenter.presentOutputSettings()
        }).disposed(by: bag)
    }
}

//MARK: - Public interface
extension GenerateReportView: GenerateReportViewInterface {
    
    func hideHud() {
        hud?.hide()
    }
}

extension GenerateReportView: InsetContent {
    func apply(inset: UIEdgeInsets) {
        formView?.tableView.contentInset = inset
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
