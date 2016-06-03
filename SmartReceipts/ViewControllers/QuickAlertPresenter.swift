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
}

extension QuickAlertPresenter where Self: UIViewController {
    func presentAlert(title: String?, message: String, dismissButton: String = NSLocalizedString("generic.button.title.ok", comment: "")) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: dismissButton, style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}