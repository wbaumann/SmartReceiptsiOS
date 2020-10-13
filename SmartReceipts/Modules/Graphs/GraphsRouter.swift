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
    func openPeriod(dayAvailable: Bool) -> Observable<GraphsAssembly.PeriodSelection>
    func openModel(dailyAvailable: Bool) -> Observable<GraphsAssembly.ModelSelection>
    func close()
}

class GraphsRouter: GraphsRouterProtocol {
    weak var moduleViewController: UIViewController!
    
    func openPeriod(dayAvailable: Bool) -> Observable<GraphsAssembly.PeriodSelection> {
        let sheet = ActionSheet()
        defer { sheet.show() }
        var actions: [Observable<GraphsAssembly.PeriodSelection>] = [
            sheet.addAction(title: LocalizedString("report")).map { .report },
            sheet.addAction(title: LocalizedString("graphs.period.week")).map { .weekly },
            sheet.addAction(title: LocalizedString("graphs.period.month")).map { .monthly }
        ]
        if dayAvailable {
            actions.append(sheet.addAction(title: LocalizedString("graphs.period.day")).map { .daily })
        }
        return .merge(actions)
    }

    func openModel(dailyAvailable: Bool) -> Observable<GraphsAssembly.ModelSelection> {
        let sheet = ActionSheet()
        defer { sheet.show() }
        var actions: [Observable<GraphsAssembly.ModelSelection>] = [
            sheet.addAction(title: LocalizedString("category_name_field")).map { .categories },
            sheet.addAction(title: LocalizedString("payment_method")).map { .paymentMethods },
        ]
        if dailyAvailable {
            actions.append(sheet.addAction(title: LocalizedString("RECEIPTMENU_FIELD_DATE")).map { .dates })
        }
        return .merge(actions)
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


