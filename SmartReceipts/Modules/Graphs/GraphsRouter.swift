//
//  GraphsRouter.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

protocol GraphsRouterProtocol {
    func openPeriod() -> Observable<GraphsAssembly.PeriodSelection>
    func openModel() -> Observable<GraphsAssembly.ModelSelection>
    func close()
}

class GraphsRouter: GraphsRouterProtocol {
    weak var moduleViewController: UIViewController!
    
    func openPeriod() -> Observable<GraphsAssembly.PeriodSelection> {
        let sheet = ActionSheet()
        defer { sheet.show() }
        return Observable<GraphsAssembly.PeriodSelection>.merge([
            sheet.addAction(title: LocalizedString("report")).map { .report },
            sheet.addAction(title: LocalizedString("receipt_action_camera")).map { .daily },
            sheet.addAction(title: LocalizedString("receipt_action_text")).map { .monthly }
        ])
    }

    func openModel() -> Observable<GraphsAssembly.ModelSelection> {
        let sheet = ActionSheet()
        defer { sheet.show() }
        return Observable<GraphsAssembly.ModelSelection>.merge([
            sheet.addAction(title: LocalizedString("category_name_field")).map { .categories },
            sheet.addAction(title: LocalizedString("payment_method")).map { .paymentMethods },
            sheet.addAction(title: LocalizedString("RECEIPTMENU_FIELD_DATE")).map { .dates }
        ])
    }
    
    func close() {
        moduleViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension GraphsRouter {
    enum Route {
        case period, model, close
    }
}


