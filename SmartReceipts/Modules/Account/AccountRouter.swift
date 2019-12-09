//
//  AccountRouter.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

protocol AccountRouterProtocol {
    func openLogin() -> Completable
    func openOcr()
}

class AccountRouter: AccountRouterProtocol {
    weak var moduleViewController: UIViewController!
    
    func openLogin() -> Completable {
        let module = AppModules.auth.build()
        module.router.show(from: moduleViewController, embedInNavController: true)
        
        let interface = module.interface(AuthModuleInterface.self)
        return Completable.create { [weak interface] event -> Disposable in
                _ = interface?.successAuth.subscribe(onNext: {
                    event(.completed)
                })
                return Disposables.create()
            }.do(onCompleted: {
                module.view.viewController.dismiss(animated: true, completion: nil)
            })
    }
    
    func openOcr() {
        let module = AppModules.OCRConfiguration.build()
        let nc = UINavigationController(rootViewController: module.view.viewController)
        moduleViewController.present(nc, animated: true, completion: nil)
    }
}
