//
//  EditTripFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift

fileprivate let NAME_ROW_TAG = "name"

class EditTripFormView: FormViewController {
    
    let errorSubject = PublishSubject<String>()
    let tripSubject = PublishSubject<WBTrip>()
    private var isNewTrip: Bool!
    
    private var trip: WBTrip?
    
    required init(trip: WBTrip?) {
        super.init(nibName: nil, bundle: nil)
        isNewTrip = trip == nil
        self.trip = trip
        if trip == nil {
            self.trip = WBTrip()
            self.trip?.startDate = NSDate().atBeginningOfDay()
            var dayComponents = DateComponents()
            dayComponents.day = Int(WBPreferences.defaultTripDuration()) - 1
            self.trip?.endDate = (Calendar.current.date(byAdding: dayComponents,
                            to: self.trip!.startDate)! as NSDate).atBeginningOfDay()
            self.trip?.defaultCurrency = Currency.currency(forCode: WBPreferences.defaultCurrency())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        
        //MARK: FORM
        form
        +++ Section()
        <<< TextRow(NAME_ROW_TAG) { row in
            row.title = LocalizedString("edit.trip.name.label")
            row.value = trip?.name
            row.add(rule: RuleRequired())
        }.onChange({ [weak self] row in
            self?.trip?.name = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.configureCell()
            if self.isNewTrip {
                _ = cell.textField.becomeFirstResponder()
            }
        })
        
        <<< DateInlineRow() { row in
            row.title = LocalizedString("edit.trip.start.date.label")
            row.value = trip?.startDate
        }.onChange({ [weak self] row in
            self?.trip?.startDate = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< DateInlineRow() { row in
            row.title = LocalizedString("edit.trip.end.date.label")
            row.value = trip?.endDate
        }.onChange({ [weak self] row in
            self?.trip?.endDate = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("edit.trip.default.currency.label")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = trip?.defaultCurrency.code ?? WBPreferences.defaultCurrency()
        }.onChange({ [weak self] row in
            self?.trip?.defaultCurrency = Currency.currency(forCode: row.value ?? WBPreferences.defaultCurrency()!)
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        <<< TextRow() { row in
            row.title = LocalizedString("edit.trip.comment.label")
            row.value = trip?.comment ?? ""
        }.onChange({ [weak self] row in
            self?.trip?.comment = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.configureCell()
        })
        
        if WBPreferences.trackCostCenter() {
            form.allSections.first! <<< TextRow() { row in
                row.title = LocalizedString("edit.trip.cost.center.label")
                row.value = trip?.costCenter ?? ""
            }.onChange({ [weak self] row in
                self?.trip?.costCenter = row.value ?? ""
            }).cellSetup({ cell, _ in
                cell.configureCell()
            })
        }
    }
    
    func done() {
        if let errors = form.rowBy(tag: NAME_ROW_TAG)?.validate() {
            if errors.count > 0 {
                errorSubject.onNext(LocalizedString("edit.trip.name.missing.alert.message"))
            } else {
                tripSubject.onNext(trip!)
            }
        }
    }
    
}

fileprivate extension BaseCell {
    fileprivate func configureCell() {
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        detailTextLabel?.textColor = AppTheme.themeColor
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}
