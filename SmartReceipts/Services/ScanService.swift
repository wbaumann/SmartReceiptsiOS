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
fileprivate let NETWORK_TIMEOUT: RxTimeInterval = 10
fileprivate let RECOGNITION_KEY = "recognition"

class ScanService {
    private let s3Service = S3Service()
    fileprivate let statusSubject = PublishSubject<ScanStatus>()
    
    var status: Observable<ScanStatus> {
        return statusSubject.asObservable()
    }
    
    func scan(image: UIImage) -> Observable<Scan> {
        if (WBPreferences.automaticScansEnabled() && FeatureFlags.ocrSupport.isEnabled &&
            AuthService.shared.isLoggedIn && ScansPurchaseTracker.shared.hasAvailableScans) {
            statusSubject.onNext(.uploading)
            return s3Service.upload(image: image)
                .flatMap({ [weak self] url -> Observable<String> in
                    if self != nil {
                        self?.statusSubject.onNext(.scanning)
                        return self!.recognize(url: url)
                    } else {
                        self?.statusSubject.onNext(.completed)
                        return Observable<String>.never()
                    }
                }).flatMap({ id -> Observable<String> in
                    return PushNotificationService.shared.rx.notificationJSON
                        .timeout(PUSH_TIMEOUT, scheduler: MainScheduler.instance)
                        .catchError({ _ -> Observable<JSON> in
                            return Observable<JSON>.just(JSON())
                        }).map({
                            return $0.dictionaryValue[RECOGNITION_KEY]?["id"].string ?? id
                        })
                }).flatMap({ [weak self] id -> Observable<Scan> in
                    self?.statusSubject.onNext(.fetching)
                    return APIAdapter.json(.get, endpoint("recognitions/\(id)"))
                        .timeout(NETWORK_TIMEOUT, scheduler: MainScheduler.instance)
                        .catchErrorJustReturn(Scan(image: image))
                        .map({ JSON($0) })
                        .map({ Scan(json: $0, image: image) })
                        .do(onNext: { [weak self] _ in
                            self?.statusSubject.onNext(.completed)
                            ScansPurchaseTracker.shared.decrementRemainingScans()
                        })
                }).catchErrorJustReturn(Scan(image: image))
        } else {
            let isFeatureEnabled = "isFeatureEnabled = \(FeatureFlags.ocrSupport.isEnabled)"
            let isLoggedIn = "isLoggedIn = \(AuthService.shared.isLoggedIn)"
            let hasAvailableScans = "hasAvailableScans = \(ScansPurchaseTracker.shared.hasAvailableScans)"
            Logger.debug("Ignoring ocr scan of as: \(isFeatureEnabled), \(isLoggedIn), \(hasAvailableScans).")
            statusSubject.onNext(.completed)
            return Observable.just(Scan(image: image))
        }
    }
    
    private func recognize(url: URL) -> Observable<String> {
        let params = [RECOGNITION_KEY: [
                        "s3_path" : "ocr/\(url.lastPathComponent)",
                        "incognito" : true ] ]
        
        return APIAdapter.jsonBody(.post, endpoint("recognitions"), parameters: params)
            .map({ JSON($0).dictionaryValue[RECOGNITION_KEY]!["id"].string })
            .filter({ $0 != nil })
            .map({ $0! })
    }
}

enum ScanStatus {
    case uploading
    case scanning
    case fetching
    case completed
    
    var localizedText: String {
        switch self {
        case .uploading: return LocalizedString("scan.status.uploading")
        case .scanning: return LocalizedString("scan.status.scanning")
        case .fetching: return LocalizedString("scan.status.fetching")
        case .completed: return ""
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .uploading: return #imageLiteral(resourceName: "upload-cloud")
        case .scanning: return #imageLiteral(resourceName: "cpu")
        case .fetching: return #imageLiteral(resourceName: "download-cloud")
        case .completed: return nil
        }
    }
}
