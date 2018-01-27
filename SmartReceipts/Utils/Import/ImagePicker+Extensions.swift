//
//  ImagePicker+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift

extension ImagePicker {
    func rx_openOn(_ viewController: UIViewController) -> Observable<UIImage?> {
        let subject = PublishSubject<UIImage?>()
        present(on: viewController, completion: { img in
            subject.onNext(img)
        })
        return subject
    }
    
    func rx_openCamera(on viewController: UIViewController) -> Observable<UIImage?> {
        let subject = PublishSubject<UIImage?>()
        presentCamera(on: viewController, completion: { img in
            subject.onNext(img)
        })
        return subject
    }
}
