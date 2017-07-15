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
final class PaymentMethodsView: FetchedCollectionViewControllerSwift {
    
    @IBOutlet private weak var addItem: UIBarButtonItem!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString("payment.methods.controller.title")
        setPresentationCellNib(TitleOnlyCell.viewNib())
        
        addItem.rx.tap.subscribe(onNext: {
            _ = self.showEditPaymentMethod().bind(to: self.presenter.paymentMethodAction)
        }).disposed(by: bag)
    }
 
    override func configureCell(_ cell: UITableViewCell, indexPath: IndexPath, object: Any) {
        let titleCell = cell as! TitleOnlyCell
        let method = object as! PaymentMethod
        titleCell.setTitle(method.method)
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
            let title = isEdit ? LocalizedString("edit.payment.method.controller.edit.title") :
                                 LocalizedString("edit.payment.method.controller.add.title")
            
        
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = LocalizedString("edit.payment.method.controller.placeholder")
                textField.text = method?.method
            }
        
            let saveTitle = isEdit ? LocalizedString("edit.payment.method.controller.update") :
                                     LocalizedString("edit.payment.method.controller.add")
            alert.addAction(UIAlertAction(title: saveTitle, style: .default, handler: { _ in
                let pm = method ?? PaymentMethod()
                pm.method = alert.textFields!.first!.text
                observer.onNext((pm: pm, update: isEdit))
            }))
                
            alert.addAction(UIAlertAction(title: LocalizedString("edit.payment.method.controller.cancel"),
                                          style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return Disposables.create()
        })
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
