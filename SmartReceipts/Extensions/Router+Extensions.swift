//
//  Router+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

extension Router {
    func openAlert(title: String?, message: String) {
        UIAlertView(title: title, message: message, delegate: nil,
                    cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
    }
    
    func showIPadForm(from: UIViewController, animated: Bool = true, setupData: Any? = nil, needNavigationController: Bool = false) {
        var forShow: UIViewController! = _view
        if let data = setupData {
            _view._presenter.setupView(data: data)
        }

        if needNavigationController {
            forShow = UINavigationController(rootViewController: _view)
        }
        
        forShow.modalTransitionStyle = .coverVertical
        forShow.modalPresentationStyle = .formSheet
        
        from.present(forShow, animated: animated, completion: nil)
    }
    
    func pushTo(controller: UINavigationController, animated: Bool = true, setupData: Any? = nil) {
        if let data = setupData {
            _view._presenter.setupView(data: data)
        }
        controller.pushViewController(_view, animated: animated)
    }
}
