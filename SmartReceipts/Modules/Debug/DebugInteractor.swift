//
//  DebugInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class DebugInteractor: Interactor {
    private let bag = DisposeBag()
    private let scanService = ScanService()
    
    var debugSubscription: AnyObserver<Bool> {
        return AnyObserver<Bool>(onNext: { value in
            DebugStates.setSubscription(value)
            if value {
                NotificationCenter.default.post(name: .SmartReceiptsAdsRemoved, object: nil)
            }
        })
    }
    
    func scan() -> Single<ScanResult> {
        var hud: PendingHUDView?
        return ImagePicker.shared.presentPicker(on: presenter._view)
            .flatMap({ [unowned self] img -> Single<ScanResult> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.scanService.status)
                return self.scanService.scan(image: img)
            }).do(onSuccess: { scan in
                hud?.hide()
            })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugInteractor {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
}
