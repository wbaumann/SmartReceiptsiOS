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
    
    var distance: Distance?
    private(set) var changedDistance: Distance?
    
    required init(trip: WBTrip, distance: Distance?) {
        super.init(nibName: nil, bundle: nil)
        self.distance = distance
        
        if let initialDistance = distance?.copy() as? Distance {
            self.changedDistance = initialDistance
        } else {
            self.changedDistance = Distance()
            self.changedDistance?.trip = trip
            self.changedDistance?.location = ""
            
            let date = WBReceiptsViewController.sharedInputCache()[SREditDistanceDateCacheKey] as? Date
            self.changedDistance?.date = date ?? trip.startDate
            self.changedDistance?.timeZone = trip.startTimeZone
            
            let amount = NSDecimalNumber(value: 0)
            let currency = trip.defaultCurrency.code!
            self.changedDistance?.rate = Price(amount: amount, currencyCode: currency)
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
            row.title = LocalizedString("edit.distance.controller.distance.label")
            row.value = changedDistance?.distance?.doubleValue
            row.add(rule: RuleRequired())
            row.setupDecimalFormat()
        }.onChange({ [weak self] row in
            self?.changedDistance?.distance = row.value == nil ? nil : NSDecimalNumber(value: row.value!)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
        })
        
        <<< DecimalRow(RATE_ROW_TAG) { row in
            row.title = LocalizedString("edit.distance.controller.rate.label")
            row.value = distance?.rate.amount.doubleValue
            row.add(rule: RuleRequired())
            row.setupDecimalFormat()
        }.onChange({ [weak self] row in
            let rate = row.value == nil ? nil : NSDecimalNumber(value: row.value!)
            let currency = self?.changedDistance?.rate.currency.code ?? WBPreferences.defaultCurrency()
            self?.changedDistance?.rate = Price(amount: rate ?? 0, currencyCode: currency!)
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
        })
        
        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("edit.distance.controller.currency.label")
            row.options = RecentCurrenciesCache.shared.cachedCurrencyCodes + Currency.allCurrencyCodes()
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
            row.title = LocalizedString("edit.distance.controller.location.label")
            row.value = changedDistance?.location
        }.onChange({ [weak self] row in
            self?.changedDistance?.location = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
        })
    
        <<< DateInlineRow() { row in
            row.title = LocalizedString("edit.distance.controller.date.label")
            row.value = changedDistance?.date
            let formatter = DateFormatter()
            formatter.configure(timeZone: changedDistance!.trip.startTimeZone)
            row.dateFormatter = formatter
        }.onChange({ [weak self] row in
            self?.changedDistance?.date = row.value
            WBReceiptsViewController.sharedInputCache()[SREditDistanceDateCacheKey] = row.value
        }).cellSetup({ cell, _ in
            cell.makeBoldTitle()
            cell.makeHighlitedValue()
        })
    
        <<< TextRow() { row in
            row.title = LocalizedString("edit.distance.controller.comment.label")
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
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    fileprivate func makeHighlitedValue() {
        detailTextLabel?.textColor = AppTheme.themeColor
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}

fileprivate extension DecimalRow {
    fileprivate func setupDecimalFormat() {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        self.formatter = numberFormatter
    }
}


