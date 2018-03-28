//
//  CategoriesPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

typealias CategoryAction = (category: WBCategory, update: Bool)

class CategoriesPresenter: Presenter {
    
    let categoryAction = PublishSubject<CategoryAction>()
    let deleteSubject = PublishSubject<WBCategory>()
    let reorderSubject = PublishSubject<(WBCategory,WBCategory)>()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
    }
    
    func presentAlert(title: String?, message: String) {
        router.openAlert(title: title, message: message)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return interactor.fetchedModelAdapter()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension CategoriesPresenter {
    var view: CategoriesViewInterface {
        return _view as! CategoriesViewInterface
    }
    var interactor: CategoriesInteractor {
        return _interactor as! CategoriesInteractor
    }
    var router: CategoriesRouter {
        return _router as! CategoriesRouter
    }
}
