//
//  CategoriesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class CategoriesInteractor: Interactor {
    
    private let bag = DisposeBag()
    
    func configureSubscribers() {
        presenter.categoryAction
            .subscribe(onNext: { [unowned self] (category: WBCategory, update: Bool) in
            self.save(category: category, update: update)
        }).disposed(by: bag)
        
        
        presenter.deleteSubject.subscribe(onNext: { [unowned self] category in
            self.delete(category: category)
        }).disposed(by: bag)
    }
    
    func save(category: WBCategory, update: Bool) {
        let db = Database.sharedInstance()!
        let success = update ? db.update(category) : db.save(category)
        
        if !success {
            presenter.presentAlert(title: nil, message: LocalizedString("edit.category.edit.failure.message"))
        }
    }
    
    func delete(category: WBCategory) {
        Database.sharedInstance().delete(category)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().fetchedAdapterForCategories()
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension CategoriesInteractor {
    var presenter: CategoriesPresenter {
        return _presenter as! CategoriesPresenter
    }
}
