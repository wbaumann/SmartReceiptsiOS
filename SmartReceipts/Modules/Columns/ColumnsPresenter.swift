//
//  ColumnsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ColumnsPresenter: Presenter {
    
    private var isCSV: Bool = false
    
    override func setupView(data: Any) {
        isCSV = data as! Bool
        interactor.columns(forCSV: isCSV).bind(to: view.columnsVar).dispose()
        
        view.setNavTitle(isCSV ? LocalizedString("columns.controller.title.csv") :
                                 LocalizedString("columns.controller.title.pdf"))
    }
    
    override func viewIsAboutToDisappear() {
        interactor.update(columns: view.columnsVar.value, forCSV: isCSV)
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ColumnsPresenter {
    var view: ColumnsViewInterface {
        return _view as! ColumnsViewInterface
    }
    var interactor: ColumnsInteractor {
        return _interactor as! ColumnsInteractor
    }
    var router: ColumnsRouter {
        return _router as! ColumnsRouter
    }
}
