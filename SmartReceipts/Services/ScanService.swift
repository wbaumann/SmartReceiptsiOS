//
//  ScanService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import SwiftyJSON

fileprivate let PUSH_TIMEOUT: RxTimeInterval = 15

class ScanService {
    private let s3Service = S3Service()
    
    func scan(image: UIImage) -> Observable<Scan> {
        if (FeatureFlags.ocrSupport.isEnabled && AuthService.shared.isLoggedIn &&
            ScansPurchaseTracker.shared.hasAvailableScans) {
            return s3Service.upload(image: image)
                .flatMap({ [weak self] url -> Observable<String> in
                    self != nil ? self!.recognize(url: url) : Observable<String>.never()
                }).flatMap({ id -> Observable<String> in
                    return PushNotificationService.shared.rx.notificationJSON
                        .timeout(PUSH_TIMEOUT, scheduler: MainScheduler.instance)
                        .catchError({ _ -> Observable<JSON> in
                            return Observable<JSON>.just(JSON())
                        }).map({
                            return $0.dictionaryValue["recognition"]?["id"].string ?? id
                        })
                }).flatMap({ id -> Observable<Scan> in
                    APIAdapter.json(.get, endpoint("recognitions/\(id)"))
                        .map({ JSON($0) })
                        .map({ Scan(json: $0, image: image) })
                        .do(onNext: { _ in ScansPurchaseTracker.shared.decrementRemainingScans() })
                })
        } else {
            let isFeatureEnabled = "isFeatureEnabled = \(FeatureFlags.ocrSupport.isEnabled)"
            let isLoggedIn = "isLoggedIn = \(AuthService.shared.isLoggedIn)"
            let hasAvailableScans = "hasAvailableScans = \(ScansPurchaseTracker.shared.hasAvailableScans)"
            Logger.debug("Ignoring ocr scan of as: \(isFeatureEnabled), \(isLoggedIn), \(hasAvailableScans).")
            return Observable.just(Scan(image: image))
        }
    }
    
    private func recognize(url: URL) -> Observable<String> {
        let params = ["recognition": [
                        "s3_path" : "ocr/\(url.lastPathComponent)",
                        "incognito" : true ] ]
        
        return APIAdapter.jsonBody(.post, endpoint("recognitions"), parameters: params)
            .map({ JSON($0).dictionaryValue["recognition"]!["id"].string })
            .filter({ $0 != nil })
            .map({ $0! })
    }
}
