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
                let name = NSNotification.Name.SmartReceiptsAdsRemoved
                NotificationCenter.default.post(name: name, object: nil)
            }
        })
    }
    
    func scan() -> Maybe<Scan> {
        var hud: PendingHUDView?
        return ImagePicker.sharedInstance().rx_openOn(presenter._view)
            .filter({ $0 != nil })
            .map({ $0! })
            .flatMap({ [unowned self] img -> Maybe<Scan> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.scanService.status)
                return self.scanService.scan(image: img).asMaybe()
            }).do(onNext: { scan in
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
