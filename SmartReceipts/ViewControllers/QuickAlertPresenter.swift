//
//  QuickAlertPresenter.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 03/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol QuickAlertPresenter: class {
    func presentAlert(_ title: String?, message: String, dismissButton: String)
    func presentAlert(_ title: String?, message: String, actions: [UIAlertAction])
    func present(alert: UIAlertController, animanted: Bool, completion: (() -> Void)?)
}

extension QuickAlertPresenter where Self: UIViewController {
    func presentAlert(_ title: String?, message: String, dismissButton: String = LocalizedString("generic.button.title.ok", comment: "")) {
        let dismissAction = UIAlertAction(title: dismissButton, style: .default, handler: nil)
        presentAlert(title, message: message, actions: [dismissAction])
    }
    
    func presentAlert(_ title: String?, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func present(alert: UIAlertController, animanted: Bool, completion: (() -> Void)?) {
        present(alert, animated: animanted, completion: completion)
    }
    
}
