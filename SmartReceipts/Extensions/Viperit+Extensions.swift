//
//  Viperit+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit
import RxSwift

extension Module {
    func interface<T>(_ type: T.Type) -> T {
        return presenter as! T
    }
}

extension Presenter {
    func presentAlert(title: String?, message: String) {
        _router.openAlert(title: title, message: message)
    }
}

extension Router {
    func openAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
        _view.present(alert, animated: true, completion: nil)
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
    
    func openModal(module: Module) {
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true)
        }, iPad: {
            module.router.showIPadForm(from: _view, needNavigationController: true)
        })
    }
}

extension UIViewController {
    func interface<T>(_ type: T.Type) -> T? {
        if let presenter = (self as? UserInterface)?._presenter {
            return presenter as? T
        }
        return nil
    }
}


