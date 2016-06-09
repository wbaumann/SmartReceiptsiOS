//
//  SettingsViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension SettingsViewController {
    func shareBackupFile(path: String, fromRect: CGRect) {
        var showRect = fromRect
        showRect.origin.y += view.frame.origin.y - fromRect.height
        
        let controller = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: path))
        controller.presentOptionsMenuFromRect(showRect, inView: view, animated: true)
        documentInteractionController = controller
    }
}