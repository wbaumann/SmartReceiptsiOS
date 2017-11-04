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
        })
    }
    
    func scan() -> Observable<Scan> {
        var hud: PendingHUDView?
        return ImagePicker.sharedInstance().rx_openOn(presenter._view)
            .filter({ $0 != nil })
            .map({ $0! })
            .flatMap({ [unowned self] img -> Observable<Scan> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                _ = self.scanService.status
                    .subscribe(onNext: { status in
                        hud?.titleLabelText = status.localizedText
                        hud?.setIcon(status.icon)
                    })
                return self.scanService.scan(image: img)
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
