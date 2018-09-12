//
//  CustomSegmentedCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift

public class PurchaseButtonCell: Cell<String>, CellType {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()
    
    public override func setup() {
        super.setup()
        selectionStyle = .none
        height = { 48 }
    }
    
    public override func update() {
        super.update()
        titleLabel.text = row.title
        selectionStyle = .default
    }
    
    public override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}

public final class PurchaseButtonRow: Row<PurchaseButtonCell>, RowType{
    
    private var _options = [String]()
    private var purchased = false
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<PurchaseButtonCell>(nibName: "PurchaseButtonCell")
    }
    
    func setSubscriptionEnd(date: Date?) {
        guard let subscriptionDate = date else {
            cell.subtitleLabel.text = ""
            return
        }
        
        let formatter = WBDateFormatter()
        if Calendar.current.isDateInToday(subscriptionDate) {
            formatter.formatter.timeStyle = .short
        }
        
        let formattedDate = formatter.formattedDate(subscriptionDate, in: NSTimeZone.local)
        cell.subtitleLabel.text = String(format:
            LocalizedString("settings.purchase.subscription.valid.until.label.base"), formattedDate!)
        
        cell.subtitleLabel.textColor = (subscriptionDate as NSDate).is(before: Date()) ?
            UIColor.red : UIColor.black
    }
    
    func markPurchased() {
        cell.activityIndicator.stopAnimating()
        purchased = true
        cell.priceLabel.text = " "
        cell.accessoryType = .checkmark
        cell.isUserInteractionEnabled = false
    }
    
    func markSpinning() {
        if !purchased {
            cell.priceLabel.text = " "
            cell.activityIndicator.startAnimating()
        }
    }
    
    func setPrice(string price: String) {
        if !purchased {
            cell.activityIndicator.stopAnimating()
            cell.accessoryView = nil
            cell.accessoryType = .none
            cell.priceLabel.text = price
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }
    
    func markError() -> Observable<Void> {
        if !purchased {
            cell.activityIndicator.stopAnimating()
            let button = UIButton(type: .custom)
            button.tintColor = UIColor.red
            button.setImage(#imageLiteral(resourceName: "info"), for: .normal)
            button.sizeToFit()
            cell.accessoryView = button
            return button.rx.tap.asObservable()
        } else {
            return Observable<Void>.never()
        }
    }
    
    func isPurchased() -> Bool {
        return purchased
    }
}
