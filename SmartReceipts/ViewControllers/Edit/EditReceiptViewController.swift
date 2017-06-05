//
//  EditReceiptViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let PresentSettingsSegueIdentifier = "PresentSettingsSegue"

private extension Selector {
    static let showErrorInfoPressed = #selector(EditReceiptViewController.showErrorInfo)
    static let refreshPressed = #selector(EditReceiptViewController.refreshRate)
    static let subscriptionInfoPressed = #selector(EditReceiptViewController.showSubscriptionInfo)
    static let unsupportedCurrencyInfoPressed = #selector(EditReceiptViewController.showUnsupportedCurrrencyInfo)
}

extension EditReceiptViewController: CurrencyExchangeServiceHandler, QuickAlertPresenter {
    func triggerExchangeRateUpdate() {
        triggerExchangeRateUpdate(false)
    }
    
    func triggerExchangeRateUpdate(_ force: Bool) {
        triggerExchangeRateUpdate(exchangeRateCell, base: tripCurrency(), target: receiptCurrency(), onDate: receiptDate(), force: force)
    }
    
    func triggerExchangeRateUpdate(_ cell: ExchangeRateCell, base: String, target: String, onDate date: Date, force: Bool) {
        Logger.debug("Trigger update")
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loading.startAnimating()
        loading.color = AppTheme.themeColor
        cell.accessoryView = loading
        
        exchangeRate(base, target: target, onDate: date, forceRefresh: force) {
            status, rate in
            
            onMainThread() {
                self.configureCell(cell, forStatus: status)
                
                guard status == .success else {
                    return
                }

                cell.entryField.text = WBReceipt.exchangeRateFormatter().string(from: rate!)
            }
        }
    }
    
    fileprivate func configureCell(_ cell: ExchangeRateCell, forStatus status: ExchangeServiceStatus) {
        switch status {
        case .success:
            cell.accessoryView = exchangeRateReloadButton()
        case .retrieveError:
            let button = warnignButton()
            button.addTarget(self, action: .showErrorInfoPressed, for: .touchUpInside)
            cell.accessoryView = button
        case .notEnabled:
            cell.accessoryView = subscriptionInfoButton()
        case .unsupportedCurrency:
            let button = warnignButton()
            button.addTarget(self, action: .unsupportedCurrencyInfoPressed, for: .touchUpInside)
            cell.accessoryView = button
        }
    }
    
    @objc fileprivate func refreshRate() {
        triggerExchangeRateUpdate(true)
    }
    
    @objc fileprivate func showErrorInfo() {
        let retryAction = UIAlertAction(title: NSLocalizedString("exchange.rate.retrieve.error.retry.button", comment: ""), style: .default) {
            action in
            
            self.triggerExchangeRateUpdate(true)
        }
        let okAction = UIAlertAction(title: NSLocalizedString("exchange.rate.retrieve.error.cancel.button", comment: ""), style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: NSLocalizedString("exchange.rate.retrieve.error.title", comment: ""), message: NSLocalizedString("exchange.rate.retrieve.error.message", comment: ""), preferredStyle: .alert)
        alert.addAction(retryAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func showSubscriptionInfo() {
        let cancelAction = UIAlertAction(title: NSLocalizedString("exchange.rate.subcsription.no.button", comment: ""), style: .cancel, handler: nil)
        let detailsAction = UIAlertAction(title: NSLocalizedString("exchange.rate.subcsription.details.button", comment: ""), style: .default) {
            _ in
            
            self.performSegue(withIdentifier: PresentSettingsSegueIdentifier, sender: nil)
        }
        presentAlert(NSLocalizedString("exchange.rate.subscription.info.title", comment: ""), message: NSLocalizedString("exchange.rate.subscription.info.message", comment: ""), actions: [detailsAction, cancelAction])
    }
    
    @objc fileprivate func showUnsupportedCurrrencyInfo() {
        presentAlert(NSLocalizedString("exchange.rate.error.unsupported.currency.title", comment: ""), message: NSLocalizedString("exchange.rate.error.unsupported.currency.message", comment: ""))
    }
    
    func defaultExchangeAccessoryButton() -> UIButton {
        if Database.sharedInstance().hasValidSubscription() {
            return exchangeRateReloadButton()
        } else {
            return subscriptionInfoButton()
        }
    }
    
    func exchangeRateReloadButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "713-refresh-1-toolbar")!, for: UIControlState())
        button.sizeToFit()
        button.addTarget(self, action: .refreshPressed, for: .touchUpInside)
        return button
    }
    
    func subscriptionInfoButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "724-info-toolbar")!, for: UIControlState())
        button.sizeToFit()
        button.addTarget(self, action: .subscriptionInfoPressed, for: .touchUpInside)
        return button
    }
    
    fileprivate func warnignButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "791-warning-toolbar")!, for: UIControlState())
        button.sizeToFit()
        return button
    }
}
