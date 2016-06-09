//
//  QuickAlertPresenter.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 03/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol QuickAlertPresenter {
    func presentAlert(title: String?, message: String, dismissButton: String)
    func presentAlert(title: String?, message: String, actions: [UIAlertAction])
}

extension QuickAlertPresenter where Self: UIViewController {
    func presentAlert(title: String?, message: String, dismissButton: String = NSLocalizedString("generic.button.title.ok", comment: "")) {
        let dismissAction = UIAlertAction(title: dismissButton, style: .Default, handler: nil)
        presentAlert(title, message: message, actions: [dismissAction])
    }
    
    func presentAlert(title: String?, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for action in actions {
            alert.addAction(action)
        }
        presentViewController(alert, animated: true, completion: nil)
    }
}