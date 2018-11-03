//
//  FilesViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 27/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
class FilesViewController: UIDocumentBrowserViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browserUserInterfaceStyle = .dark
        allowsDocumentCreation = false
        view.tintColor = .white
        additionalTrailingNavigationBarButtonItems = [
            UIBarButtonItem(title: LocalizedString("DIALOG_CANCEL"), style: .plain, target: self, action: #selector(close))
        ]
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
}
