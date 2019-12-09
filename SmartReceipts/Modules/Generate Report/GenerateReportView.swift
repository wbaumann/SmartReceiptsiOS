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
    var hud: PendingHUDView?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        formView = GenerateReportFormView()
        addChild(formView!)
        formView?.view.frame = view.bounds
        view.addSubview(formView!.view)
        
        super.viewDidLoad()
        configureUIActions()
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.presenter.close()
        }).disposed(by: bag)
        
        formView?.onSettingsTap.subscribe(onNext: { [weak self] _ in
            self?.presenter.presentOutputSettings()
        }).disposed(by: bag)
    }
}

extension GenerateReportView: TabHasMainAction {
    func mainAction() {
        guard let navView = navigationController?.view, let selection = formView?.selection else { return }
        hud = PendingHUDView.show(on: navView)
        presenter.generateReport(selection: selection)
    }
    
    var actionIcon: UIImage {
        return #imageLiteral(resourceName: "share-2")
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
