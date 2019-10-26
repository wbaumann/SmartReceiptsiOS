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
    @IBOutlet private var _imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet fileprivate var imageConstraint: NSLayoutConstraint!
    
    private lazy var formatter: NumberFormatter = .exchangeFieldFormatter
    
    weak var alertPresenter: QuickAlertPresenter?
    
    private let bag = DisposeBag()
    private var error: CurrencyExchangeError?
    
    public override func setup() {
        textField = valueField
        titleLabel = label
        super.setup()
        titleLabel?.font = AppTheme.boldFont
        imageConstraint.isActive = true
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
    
    public override func update() {
        super.update()
        titleLabel?.text = row.title
        updateButton()
    }
    
    func setCell(image: UIImage) {
        _imageView.image = image
        imageConstraint.isActive = true
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
    
    open override func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
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
        module.router.show(from: openFrom, embedInNavController: true)
    }
}


public final class ExchangeRateRow: Row<ExchangeRateCell>, RowType, FormatterConformance, FieldRowConformance {
    // FormatterConformance
    public var formatter: Formatter? = NumberFormatter.exchangeFieldFormatter
    public var useFormatterDuringInput: Bool = false
    public var useFormatterOnDidBeginEditing: Bool? = true
    // FieldRowConformance
    public var titlePercentage: CGFloat? = nil
    public var placeholder: String? = nil
    public var placeholderColor: UIColor? = nil
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ExchangeRateCell>(nibName: "ExchangeRateCell")
        displayValueFor = { value in
            guard let value = value else { return nil }
            let number = NSNumber(value: value)
            return NumberFormatter.exchangeFieldFormatter.string(from: number)
        }
    }
    
    let responseSubject = PublishSubject<ExchangeResponse>()
    let updateTap = PublishSubject<Void>()
}
