//
//  EditReceiptFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

class EditReceiptFormView: FormViewController {
    
    private let CURRENCY_ROW_TAG = "CurrencyRow"
    private let NAME_ROW_TAG = "NameRow"
    
    let receiptSubject = PublishSubject<WBReceipt>()
    let errorSubject = PublishSubject<String>()
    
    private var receipt: WBReceipt!
    private var trip: WBTrip!
    private var taxCalculator: TaxCalculator?
    private let disposeBag = DisposeBag()
    
    init(trip: WBTrip, receipt: WBReceipt?) {
        super.init(nibName: nil, bundle: nil)
        self.trip = trip
        if receipt == nil {
            self.receipt = WBReceipt()
            self.receipt.setPrice(NSDecimalNumber.zero, currency: trip.defaultCurrency.code)
            self.receipt.date = Date()
            self.receipt.category = allCategories().first!
            self.receipt.exchangeRate = NSDecimalNumber.zero
            self.receipt.isReimbursable = true
            self.receipt.isFullPage = WBPreferences.assumeFullPage()
        } else {
            self.receipt = receipt!.copy() as! WBReceipt
        }
        taxCalculator = WBPreferences.includeTaxField() ? TaxCalculator() : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
        <<< TextRow(NAME_ROW_TAG) { row in
            row.title = LocalizedString("edit.receipt.name.label")
            row.placeholder = LocalizedString("edit.receipt.name.placeholder")
            row.value = receipt.name
        }.onChange({ [unowned self] row in
            self.receipt.name = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
    
        <<< DecimalRow() { row in
            row.title = LocalizedString("edit.receipt.price.label")
            row.placeholder = LocalizedString("edit.receipt.price.placeholder")
            row.value = receipt.price().amount.doubleValue != 0 ?
                receipt.price().amount.doubleValue : nil
        }.onChange({ [unowned self] row in
            if let dec = row.value {
                let amount = NSDecimalNumber(value: dec)
                self.receipt.setPrice(amount, currency: self.receipt.currency.code)
                self.taxCalculator?.priceSubject.onNext(Decimal(dec))
            } else {
                self.taxCalculator?.priceSubject.onNext(nil)
            }
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
            
        <<< DecimalRow() { row in
            row.hidden = Condition.init(booleanLiteral: !WBPreferences.includeTaxField())
            row.title = LocalizedString("edit.receipt.tax.label")
            row.placeholder = LocalizedString("edit.receipt.tax.placeholder")
            row.value = receipt.tax()?.amount.doubleValue
            if let calculator = taxCalculator {
                calculator.taxSubject.subscribe(onNext: {
                    row.value = Double(string: $0)
                    row.updateCell()
                }).disposed(by: disposeBag)
            }
            
        }.onChange({ [unowned self] row in
            self.receipt.setTax(NSDecimalNumber(value: row.value ?? 0))
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< PickerInlineRow<String>(CURRENCY_ROW_TAG) { row in
            row.title = LocalizedString("edit.trip.default.currency.label")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = receipt.currency.code
        }.onChange({ [unowned self] row in
            if let code = row.value {
                self.receipt.setPrice(self.receipt.priceAmount, currency: code)
            }
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
            
        <<< DecimalRow() { row in
            row.title = LocalizedString("edit.receipt.exchange.rate.label")
            row.hidden = Condition.function([CURRENCY_ROW_TAG], { form -> Bool in
                if let picker = form.rowBy(tag: self.CURRENCY_ROW_TAG) as? PickerInlineRow<String> {
                    return picker.value == self.trip.defaultCurrency.code
                } else {
                    return false
                }
            })
            row.value = receipt.exchangeRate?.doubleValue
        }.onChange({ [unowned self] row in
            self.receipt.exchangeRate = NSDecimalNumber(value: row.value ?? 0)
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< DateInlineRow() { row in
            row.title = LocalizedString("edit.receipt.date.label")
            row.value = receipt.date
        }.onChange({ [unowned self] row in
            self.receipt.date = row.value ?? Date()
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("edit.receipt.category.label")
            row.options = allCategories()
            row.value = receipt.category
        }.onChange({ [unowned self] row in
            self.receipt.category = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< TextRow() { row in
            row.title = LocalizedString("edit.receipt.comment.label")
            row.placeholder = LocalizedString("edit.receipt.comment.placeholder")
            row.value = receipt.comment
        }.onChange({ [unowned self] row in
            self.receipt.comment = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
            
        <<< PickerInlineRow<PaymentMethod>() { row in
            row.title = LocalizedString("edit.receipt.payment.method.label")
            row.options = Database.sharedInstance().fetchedAdapterForPaymentMethods().allObjects() as! [PaymentMethod]
            row.hidden = Condition.init(booleanLiteral: !WBPreferences.usePaymentMethods())
        }.onChange({ [unowned self] row in
            self.receipt.paymentMethod = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
            
        <<< CheckRow() { row in
            row.title = LocalizedString("edit.receipt.reimbursable.label")
            row.value = receipt.isReimbursable
        }.onChange({ [unowned self] row in
            self.receipt.isReimbursable = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
            cell.tintColor = AppTheme.themeColor
        })

        <<< CheckRow() { row in
            row.title = LocalizedString("edit.receipt.full.page.label")
            row.value = receipt.isFullPage
        }.onChange({ [unowned self] row in
            self.receipt.isFullPage = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
            cell.tintColor = AppTheme.themeColor
        })
        
    }
    
    func validate() {
        if !WBTextUtils.isProperName((form.rowBy(tag: NAME_ROW_TAG) as! TextRow).value) {
            errorSubject.onNext(LocalizedString("edit.receipt.name.invalid.alert.message"))
        } else {
            receipt.trip = trip
            receiptSubject.onNext(receipt)
        }
    }
    
    private func allCategories() -> [String] {
        var result = [String]()
        for category in Database.sharedInstance().listAllCategories() {
            result.append(category.name)
        }
        return result
    }
}

fileprivate extension BaseCell {
    fileprivate func configureCell() {
        textLabel?.font = AppTheme.boldFont
        detailTextLabel?.textColor = AppTheme.themeColor
        detailTextLabel?.font = AppTheme.boldFont
    }
}
