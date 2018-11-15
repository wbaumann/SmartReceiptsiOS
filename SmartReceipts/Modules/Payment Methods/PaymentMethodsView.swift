//
//  PaymentMethodsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol PaymentMethodsViewInterface {
}

//MARK: PaymentMethodsView Class
final class PaymentMethodsView: FetchedTableViewController {
    
    @IBOutlet private weak var addItem: UIBarButtonItem!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString("payment_methods")
        
        addItem.rx.tap.subscribe(onNext: {
            _ = self.showEditPaymentMethod().bind(to: self.presenter.paymentMethodAction)
        }).disposed(by: bag)
    }
    
    override func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        let method = item as! PaymentMethod
        cell.textLabel?.text = method.method
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return presenter.fetchedModelAdapter()
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        presenter.deleteSubject.onNext(object as! PaymentMethod)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        let method = tapped as! PaymentMethod
        showEditPaymentMethod(method).bind(to: presenter.paymentMethodAction).disposed(by: bag)
    }
    
    func showEditPaymentMethod(_ method: PaymentMethod? = nil) -> Observable<PaymentMethodAction> {
        return Observable<PaymentMethodAction>.create({ [unowned self] observer -> Disposable in

            let isEdit = method != nil
            let title = isEdit ? LocalizedString("payment_method_edit") :
                                 LocalizedString("payment_method_add")
            
        
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = LocalizedString("payment_method")
                textField.text = method?.method
            }
        
            let saveTitle = isEdit ? LocalizedString("update") :
                                     LocalizedString("add")
            alert.addAction(UIAlertAction(title: saveTitle, style: .default, handler: { [unowned self] _ in
                let pm = method ?? PaymentMethod()
                let method = alert.textFields!.first!.text
                if self.validate(method: method) {
                    pm.method = method
                    observer.onNext((pm: pm, update: isEdit))
                }
            }))
                
            alert.addAction(UIAlertAction(title: LocalizedString("DIALOG_CANCEL"),
                                          style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return Disposables.create()
        })
    }
    
    private func validate(method: String?) -> Bool {
        if method == nil || method!.isEmpty {
            presenter.presentAlert(title: LocalizedString("edit.payment.method.controller.save.error.title"),
                                 message: LocalizedString("edit.payment.method.controller.save.error.message"))
            return false
        }
        
        return true
    }
}

//MARK: - Public interface
extension PaymentMethodsView: PaymentMethodsViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension PaymentMethodsView {
    var presenter: PaymentMethodsPresenter {
        return _presenter as! PaymentMethodsPresenter
    }
    var displayData: PaymentMethodsDisplayData {
        return _displayData as! PaymentMethodsDisplayData
    }
}
