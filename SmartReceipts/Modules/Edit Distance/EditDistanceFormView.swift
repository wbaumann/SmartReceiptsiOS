//
//  EditDistanceFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka

fileprivate let SREditDistanceDateCacheKey = "SREditDistanceDateCacheKey"

fileprivate let DISTANCE_ROW_TAG  = "distanceTag"
fileprivate let RATE_ROW_TAG      = "rateTag"

class EditDistanceFormView: FormViewController {
    
    private var distance: Distance?
    private(set) var changedDistance: Distance?
    
    required init(trip: WBTrip, distance: Distance?) {
        super.init(nibName: nil, bundle: nil)
        self.distance = distance
        
        if let initialDistance = distance?.copy() as? Distance {
            changedDistance = initialDistance
        } else {
            changedDistance = Distance()
            changedDistance?.trip = trip
            changedDistance?.location = ""
            
            let date = ReceiptsView.sharedInputCache[SREditDistanceDateCacheKey]
            changedDistance?.date = date ?? trip.startDate
            changedDistance?.timeZone = TimeZone.current
            
            let amount = NSDecimalNumber(value: WBPreferences.distanceRateDefaultValue())
            let currency = trip.defaultCurrency.code!
            changedDistance?.rate = Price(amount: amount, currencyCode: currency)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: FORM
        
        form +++ Section()
        <<< DecimalRow(DISTANCE_ROW_TAG) { row in
            row.title = LocalizedString("pref_distance_header")
            row.value = changedDistance?.distance?.doubleValue
            row.add(rule: RuleRequired())
            row.setupDecimalFormat()
        }.onChange({ [weak self] row in
            self?.changedDistance?.distance = row.value == nil ? nil : NSDecimalNumber(value: row.value!)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
        
        <<< DecimalRow(RATE_ROW_TAG) { row in
            row.title = LocalizedString("distance_rate_field")
            if changedDistance?.rate.amount.decimalValue != 0 {
                row.value = changedDistance?.rate.amount.doubleValue
            }
            row.add(rule: RuleRequired())
            row.setupDecimalFormat()
        }.onChange({ [weak self] row in
            let rate = row.value == nil ? nil : NSDecimalNumber(value: row.value!)
            let currency = self?.changedDistance?.rate.currency.code ?? WBPreferences.defaultCurrency()
            self?.changedDistance?.rate = Price(amount: rate ?? 0, currencyCode: currency!)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
        
        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("RECEIPTMENU_FIELD_CURRENCY")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = changedDistance?.rate.currency.code
        }.onChange({ [weak self] row in
            let amount = self?.changedDistance?.rate?.amount ?? NSDecimalNumber(value: 0)
            let currency = row.value ?? WBPreferences.defaultCurrency()!
            self?.changedDistance?.rate = Price(amount: amount, currencyCode: currency)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.makeHighlitedValue()
        })
        
        <<< TextRow() { row in
            row.title = LocalizedString("distance_location_field")
            row.value = changedDistance?.location
        }.onChange({ [weak self] row in
            self?.changedDistance?.location = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
        })
    
        <<< DateInlineRow() { [] row in
            row.title = LocalizedString("RECEIPTMENU_FIELD_DATE")
            row.value = changedDistance?.date
            row.dateFormatter?.timeZone = changedDistance?.timeZone
        }.onChange({ [weak self] row in
            self?.changedDistance?.date = row.value
            ReceiptsView.sharedInputCache[SREditDistanceDateCacheKey] = row.value
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.makeHighlitedValue()
        }).onExpandInlineRow({ _, _, datePickerRow in
            datePickerRow.cell.datePicker.timeZone = self.changedDistance?.timeZone
        })
    
        <<< TextRow() { row in
            row.title = LocalizedString("RECEIPTMENU_FIELD_COMMENT")
            row.value = changedDistance?.comment
        }.onChange({ [weak self] row in
            self?.changedDistance?.comment = row.value
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
        })
    }
    
    /**
     Validate and return erorrs description, if Distance Row or/and Rate Row has errors.
     @return Errors description or empty string
     */
    func validate() -> String {
        var result = ""
        if let errors = form.rowBy(tag: DISTANCE_ROW_TAG)?.validate() {
            errors.count > 0 ? result.appendIssue(LocalizedString("edit.distance.controller.validation.distance.missing")) : ()
        }
        
        if let errors = form.rowBy(tag: RATE_ROW_TAG)?.validate() {
            errors.count > 0 ? result.appendIssue(LocalizedString("edit.distance.controller.validation.rate.missing")) : ()
        }
        
        return result
    }
}

fileprivate extension BaseCell {
    fileprivate func makeBoldTitle() {
        textLabel?.font = AppTheme.boldFont
    }
    
    fileprivate func makeHighlitedValue() {
        detailTextLabel?.textColor = AppTheme.primaryColor
        detailTextLabel?.font = AppTheme.boldFont
    }
}

fileprivate extension DecimalRow {
    fileprivate func setupDecimalFormat() {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        formatter = numberFormatter
    }
}


