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
            changedDistance?.date = date ?? (WBPreferences.defaultToFirstReportDate() ? trip.startDate : Date())
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
        <<< DecimalRow(DISTANCE_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("distance_distance_field")
            row.value = self.changedDistance?.distance?.doubleValue
            row.add(rule: RuleRequired())
            row.setupDecimalFormat()
        }.onChange({ [weak self] row in
            self?.changedDistance?.distance = row.value == nil ? nil : NSDecimalNumber(value: row.value!)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
        
        <<< DecimalRow(RATE_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("distance_rate_field")
            if self.changedDistance?.rate.amount.decimalValue != 0 {
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
        
        <<< PickerInlineRow<String>() { [unowned self] row in
            row.title = LocalizedString("dialog_currency_field")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = self.changedDistance?.rate.currency.code
        }.onChange({ [weak self] row in
            let amount = self?.changedDistance?.rate?.amount ?? NSDecimalNumber(value: 0)
            let currency = row.value ?? WBPreferences.defaultCurrency()!
            self?.changedDistance?.rate = Price(amount: amount, currencyCode: currency)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.makeHighlitedValue()
        })
        
        <<< TextRow() { [unowned self] row in
            row.title = LocalizedString("distance_location_field")
            row.value = self.changedDistance?.location
        }.onChange({ [weak self] row in
            self?.changedDistance?.location = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
        })
    
        <<< DateInlineRow() { [unowned self] row in
            row.title = LocalizedString("distance_date_field")
            row.value = self.changedDistance?.date
            row.dateFormatter?.timeZone = self.changedDistance?.timeZone
            row.dateFormatter?.addWeekdayFormat()
        }.onChange({ [weak self] row in
            self?.changedDistance?.date = row.value
            ReceiptsView.sharedInputCache[SREditDistanceDateCacheKey] = row.value
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.makeHighlitedValue()
        }).onExpandInlineRow({ [unowned self] _, _, datePickerRow in
            datePickerRow.cell.datePicker.timeZone = self.changedDistance?.timeZone
        })
    
        <<< TextRow() { [unowned self] row in
            row.title = LocalizedString("distance_comment_field")
            row.value = self.changedDistance?.comment
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
            errors.count > 0 ? result.appendIssue(LocalizedString("edit_distance_controller_validation_distance_missing")) : ()
        }
        
        if let errors = form.rowBy(tag: RATE_ROW_TAG)?.validate() {
            errors.count > 0 ? result.appendIssue(LocalizedString("edit_distance_controller_validation_rate_missing")) : ()
        }
        
        return result
    }
}

fileprivate extension BaseCell {
    func makeBoldTitle() {
        textLabel?.font = AppTheme.boldFont
    }
    
    func makeHighlitedValue() {
        detailTextLabel?.textColor = AppTheme.primaryColor
        detailTextLabel?.font = AppTheme.boldFont
    }
}

fileprivate extension DecimalRow {
    func setupDecimalFormat() {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        formatter = numberFormatter
    }
}


