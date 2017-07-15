//
//  CategoriesView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol CategoriesViewInterface {
}

//MARK: CategoriesView Class
final class CategoriesView: FetchedCollectionViewControllerSwift {
    
    @IBOutlet private weak var addItem: UIBarButtonItem!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString("categories.controller.title")
        setPresentationCellNib(CategoryCell.viewNib())
        
        addItem.rx.tap.subscribe(onNext: {
            _ = self.showEditCategory().bind(to: self.presenter.categoryAction)
        }).disposed(by: bag)
    }
    
    override func configureCell(_ cell: UITableViewCell, indexPath: IndexPath, object: Any) {
        let categoryCell = cell as! CategoryCell
        let category = object as! WBCategory
        categoryCell.textLabel?.text = category.name
        categoryCell.detailTextLabel?.text = category.code
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return presenter.fetchedModelAdapter()
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        presenter.deleteSubject.onNext(object as! WBCategory)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        let category = tapped as! WBCategory
        showEditCategory(category).bind(to: presenter.categoryAction).disposed(by: bag)
    }
    
    func showEditCategory(_ category: WBCategory? = nil) -> Observable<CategoryAction> {
        return Observable<CategoryAction>.create({ [unowned self] observer -> Disposable in
            
            let isEdit = category != nil
            let title = isEdit ? LocalizedString("edit.category.edit.title.edit") :
                                 LocalizedString("edit.category.edit.title.new")
            
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = LocalizedString("edit.category.edit.placeholder.name")
                textField.text = category?.name
            }
            
            alert.addTextField { textField in
                textField.placeholder = LocalizedString("edit.category.edit.placeholder.code")
                textField.text = category?.code
            }
            
            let saveTitle = isEdit ? LocalizedString("edit.category.edit.button.update") :
                                     LocalizedString("edit.category.edit.button.add")
            alert.addAction(UIAlertAction(title: saveTitle, style: .default, handler: { [unowned self] _ in
                let forSave = category ?? WBCategory()
                let name = alert.textFields!.first!.text
                if self.validate(name: name) {
                    forSave.name = name
                    forSave.code = alert.textFields!.last!.text
                    observer.onNext((category: forSave, update: isEdit))
                }
            }))
            
            alert.addAction(UIAlertAction(title: LocalizedString("edit.payment.method.controller.cancel"),
                                          style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return Disposables.create()
        })
    }
    
    private func validate(name: String?) -> Bool {
        if name == nil || name!.isEmpty {
            presenter.presentAlert(title: nil, message: LocalizedString("edit.payment.method.controller.save.error.message"))
            return false
        }
        return true
    }
}

//MARK: - Public interface
extension CategoriesView: CategoriesViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension CategoriesView {
    var presenter: CategoriesPresenter {
        return _presenter as! CategoriesPresenter
    }
    var displayData: CategoriesDisplayData {
        return _displayData as! CategoriesDisplayData
    }
}
