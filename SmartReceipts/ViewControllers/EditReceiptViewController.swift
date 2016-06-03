//
//  EditReceiptViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private extension Selector {
    static let showErrorInfoPressed = #selector(EditReceiptViewController.showErrorInfo)
    static let refreshPressed = #selector(EditReceiptViewController.refreshRate)
    static let subscriptionInfoPressed = #selector(EditReceiptViewController.showSubscriptionInfo)
}

extension EditReceiptViewController: CurrencyExchangeServiceHandler, QuickAlertPresenter {
    func triggerExchangeRateUpdate() {
        triggerExchangeRateUpdate(false)
    }
    
    func triggerExchangeRateUpdate(force: Bool) {
        triggerExchangeRateUpdate(exchangeRateCell, base: tripCurrency(), target: receiptCurrency(), onDate: receiptDate(), force: force)
    }
    
    func triggerExchangeRateUpdate(cell: ExchangeRateCell, base: String, target: String, onDate date: NSDate, force: Bool) {
        Log.debug("Trigger update")
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loading.startAnimating()
        loading.color = WBCustomization.themeColor()
        cell.accessoryView = loading
        
        exchangeRate(base, target: target, onDate: date, forceRefresh: force) {
            status, rate in
            
            onMainThread() {
                self.configureCell(cell, forStatus: status)
                
                guard status == .Success else {
                    return
                }

                cell.entryField.text = WBReceipt.exchangeRateFormatter().stringFromNumber(rate!)
            }
        }
    }
    
    private func configureCell(cell: ExchangeRateCell, forStatus status: ExchangeServiceStatus) {
        switch status {
        case .Success:
            cell.accessoryView = exchangeRateReloadButton()
        case .RetrieveError:
            let button = UIButton(type: .Custom)
            button.setImage(UIImage(named: "791-warning-toolbar")!, forState: .Normal)
            button.sizeToFit()
            button.addTarget(self, action: .showErrorInfoPressed, forControlEvents: .TouchUpInside)
            cell.accessoryView = button
        case .NotEnabled:
            cell.accessoryView = subscriptionInfoButton()
            break
        }
    }
    
    @objc private func refreshRate() {
        triggerExchangeRateUpdate(true)
    }
    
    @objc private func showErrorInfo() {
        let retryAction = UIAlertAction(title: NSLocalizedString("exchange.rate.retrieve.error.retry.button", comment: ""), style: .Default) {
            action in
            
            self.triggerExchangeRateUpdate(true)
        }
        let okAction = UIAlertAction(title: NSLocalizedString("exchange.rate.retrieve.error.cancel.button", comment: ""), style: .Cancel, handler: nil)
        
        let alert = UIAlertController(title: NSLocalizedString("exchange.rate.retrieve.error.title", comment: ""), message: NSLocalizedString("exchange.rate.retrieve.error.message", comment: ""), preferredStyle: .Alert)
        alert.addAction(retryAction)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @objc private func showSubscriptionInfo() {
        presentAlert(NSLocalizedString("exchange.rate.subscription.info.title", comment: ""), message: NSLocalizedString("exchange.rate.subscription.info.message", comment: ""))
    }
    
    func defaultExchangeAccessoryButton() -> UIButton {
        if Database.sharedInstance().hasValidSubscription() {
            return exchangeRateReloadButton()
        } else {
            return subscriptionInfoButton()
        }
    }
    
    func exchangeRateReloadButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "713-refresh-1-toolbar")!, forState: .Normal)
        button.sizeToFit()
        button.addTarget(self, action: .refreshPressed, forControlEvents: .TouchUpInside)
        return button
    }
    
    func subscriptionInfoButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "724-info-toolbar")!, forState: .Normal)
        button.sizeToFit()
        button.addTarget(self, action: .subscriptionInfoPressed, forControlEvents: .TouchUpInside)
        return button
    }
}