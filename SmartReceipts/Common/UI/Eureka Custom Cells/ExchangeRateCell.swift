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
    
    @objc func valueChanged(){
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
                button.setImage(#imageLiteral(resourceName: "alert-triangle"), for: .normal)
            case .notEnabled:
                button.setImage(#imageLiteral(resourceName: "info"), for: .normal)
            }
        } else {
            let img = PurchaseService.hasValidSubscriptionValue ? #imageLiteral(resourceName: "refresh-cw") : #imageLiteral(resourceName: "info")
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
            if PurchaseService.hasValidSubscriptionValue {
                row().updateTap.onNext(())
            } else {
                showSubscriptionInfo()
            }
        }
    }
    
    private func row() -> ExchangeRateRow {
        return (row as! ExchangeRateRow)
    }
    
    private func showErrorInfo() {
        let retryAction = UIAlertAction(title: LocalizedString("exchange_rate_retrieve_error_retry_button"), style: .default) {
            [unowned self] action in
            self.row().updateTap.onNext(())
        }
        let okAction = UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: LocalizedString("generic_button_title_ok"), message: LocalizedString("exchange_rate_retrieve_error_message"), preferredStyle: .alert)
        alert.addAction(retryAction)
        alert.addAction(okAction)
        alertPresenter?.present(alert: alert, animanted: true, completion: nil)
    }
    
    private func showSubscriptionInfo() {
        let cancelAction = UIAlertAction(title: LocalizedString("apprating_dialog_negative"), style: .default, handler: nil)
        let detailsAction = UIAlertAction(title: LocalizedString("exchange_rate_subcsription_details_button"), style: .default) {
            _ in self.openSettings()
        }
        alertPresenter?.presentAlert(LocalizedString("pro_subscription"),
                            message: LocalizedString("exchange_rate_subscription_info_message"),
                            actions: [detailsAction, cancelAction])
    }
    
    private func showUnsupportedCurrrencyInfo() {
        alertPresenter?.presentAlert(LocalizedString("generic_error_alert_title"),
                            message: LocalizedString("exchange_rate_error_unsupported_currency_message"),
                      dismissButton: LocalizedString("generic_button_title_ok"))
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
