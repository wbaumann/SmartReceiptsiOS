//
//  MFMailComposeViewController+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import MessageUI

extension MFMailComposeViewController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return nil
    }
    
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return nil
    }
    
}
