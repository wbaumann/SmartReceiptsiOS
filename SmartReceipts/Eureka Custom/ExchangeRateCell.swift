//
//  ExchangeRateCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift

public class ExchangeRateCell: DecimalCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet weak var valueField: UITextField!
    
    weak var alertPresenter: QuickAlertPresenter?
    
    private let bag = DisposeBag()
    private var error: CurrencyExchangeError?
    
    public override func setup() {
        textField = valueField
        titleLabel = label
        super.setup()
        titleLabel?.font = AppTheme.boldFont
        textField.addTarget(self, action: #selector(ExchangeRateCell.valueChanged), for: .valueChanged)
        updateButton()
        
        row().responseSubject.subscribe(onNext: { [unowned self] response in
            self.error = response.error
            if response.error == nil {
                self.row.value = response.value?.doubleValue
            }
            self.row.reload()
            self.updateButton()
        }).disposed(by: bag)
    }
    
    func valueChanged(){
        row.value = (textField.text != nil || !textField.text!.isEmpty) ?
            NSDecimalNumber(orZeroUsingCurrentLocale: textField.text).doubleValue : nil
        row.updateCell()
    }
    
    public override func update() {
        super.update()
        titleLabel?.text = row.title
        textField?.text = row.value == nil ? nil : NSDecimalNumber(value: row.value!).stringValue
        updateButton()
    }
    
    private func updateButton() {
        if error != nil {
            switch error! {
            case .retriveError, .unsupportedCurrency:
                button.setImage(#imageLiteral(resourceName: "791-warning-toolbar"), for: .normal)
            case .notEnabled:
                button.setImage(#imageLiteral(resourceName: "724-info-toolbar"), for: .normal)
            }
        } else {
            let img = PurchaseService().hasValidSubscriptionValue() ? #imageLiteral(resourceName: "713-refresh-1-toolbar") : #imageLiteral(resourceName: "724-info-toolbar")
            button.setImage(img, for: .normal)
        }
    }
    
    @IBAction private func onButtonTap() {
        if error != nil {
            switch error! {
            case .retriveError:
                showErrorInfo()
            case .unsupportedCurrency:
                showUnsupportedCurrrencyInfo()
            case .notEnabled:
                showSubscriptionInfo()
            }
        } else {
            if PurchaseService().hasValidSubscriptionValue() {
                row().updateTap.onNext()
            } else {
                showSubscriptionInfo()
            }
        }
    }
    
    private func row() -> ExchangeRateRow {
        return (row as! ExchangeRateRow)
    }
    
    private func showErrorInfo() {
        let retryAction = UIAlertAction(title: LocalizedString("exchange.rate.retrieve.error.retry.button"), style: .default) {
            [unowned self] action in
            self.row().updateTap.onNext()
        }
        let okAction = UIAlertAction(title: LocalizedString("exchange.rate.retrieve.error.cancel.button"), style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: LocalizedString("exchange.rate.retrieve.error.title"), message: LocalizedString("exchange.rate.retrieve.error.message"), preferredStyle: .alert)
        alert.addAction(retryAction)
        alert.addAction(okAction)
        alertPresenter?.present(alert: alert, animanted: true, completion: nil)
    }
    
    private func showSubscriptionInfo() {
        let cancelAction = UIAlertAction(title: LocalizedString("exchange.rate.subcsription.no.button"), style: .cancel, handler: nil)
        let detailsAction = UIAlertAction(title: LocalizedString("exchange.rate.subcsription.details.button"), style: .default) {
            _ in self.openSettings()
        }
        alertPresenter?.presentAlert(LocalizedString("exchange.rate.subscription.info.title"),
                            message: LocalizedString("exchange.rate.subscription.info.message"),
                            actions: [detailsAction, cancelAction])
    }
    
    private func showUnsupportedCurrrencyInfo() {
        alertPresenter?.presentAlert(LocalizedString("exchange.rate.error.unsupported.currency.title"),
                            message: LocalizedString("exchange.rate.error.unsupported.currency.message"),
                      dismissButton: LocalizedString("generic.button.title.ok"))
    }
    
    private func openSettings() {
        let openFrom = alertPresenter as! UIViewController
        let module = AppModules.settings.build()
        executeFor(iPhone: {
            module.router.show(from: openFrom, embedInNavController: true)
        }, iPad: {
            module.router.showIPadForm(from: openFrom, needNavigationController: true)
        })
    }
}


public final class ExchangeRateRow: Row<ExchangeRateCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ExchangeRateCell>(nibName: "ExchangeRateCell")
    }
    
    let responseSubject = PublishSubject<ExchangeResponse>()
    let updateTap = PublishSubject<Void>()
}
