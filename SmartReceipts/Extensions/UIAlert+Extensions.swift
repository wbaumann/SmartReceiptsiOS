//
//  UIAlert+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa

extension UIAlertController {
    static func showInfo(text: String, on: UIViewController? = nil) -> Observable<Void> {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        let result = Observable<Void>.create { observer -> Disposable in
            let action = UIAlertAction(title: LocalizedString("generic.button.title.ok"), style: .default, handler: { _ in
                observer.onNext()
                observer.onCompleted()
            })
            controller.addAction(action)
            return Disposables.create()
        }
        if let vc = on ?? UIApplication.shared.keyWindow?.rootViewController {
            vc.present(controller, animated: true, completion: nil)
        } else { Logger.error("Can't show UIAlertController on nil ViewController") }
        return result
    }
}
