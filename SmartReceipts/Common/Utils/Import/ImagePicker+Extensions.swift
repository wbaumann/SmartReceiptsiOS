//
//  ImagePicker+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift

extension ImagePicker {
    func rx_openOn(_ viewController: UIViewController) -> Single<UIImage?> {
        return .create { [weak self] single -> Disposable in
            self?.present(on: viewController, completion: { img in
                single(.success(img))
            })
            return Disposables.create()
        }
    }
    
    func rx_openCamera(on viewController: UIViewController) -> Single<UIImage?> {
        return .create { [weak self] single -> Disposable in
            self?.presentCamera(on: viewController, completion: { img in
                single(.success(img))
            })
            return Disposables.create()
        }
    }
}
