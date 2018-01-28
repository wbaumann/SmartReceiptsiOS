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
    private var s3Service: S3Service!
    private var recognitionAPI: RecognitionAPI!
    private var pushNotificationService: PushNotificationService!
    private var authService: AuthServiceInterface!
    private var scansPurchaseTracker: ScansPurchaseTracker!
    fileprivate let statusSubject = PublishSubject<ScanStatus>()
    
    init(s3Service: S3Service,
         recognitionAPI: RecognitionAPI,
         pushService: PushNotificationService,
         authService: AuthServiceInterface,
         scansPurchaseTracker: ScansPurchaseTracker)
    {
        self.s3Service = s3Service
        self.recognitionAPI = recognitionAPI
        self.pushNotificationService = pushService
        self.authService = authService
        self.scansPurchaseTracker = scansPurchaseTracker
    }
    
    convenience init(){
        self.init(s3Service: S3Service(),
                  recognitionAPI: RecognitionAPI(),
                  pushService: PushNotificationService.shared,
                  authService: AuthService.shared,
                  scansPurchaseTracker: ScansPurchaseTracker.shared)
    }
    
    var status: Observable<ScanStatus> {
        return statusSubject.asObservable()
    }
    
    func scan(image: UIImage) -> Observable<Scan> {
        let doc = ReceiptDocument.makeDocumentFrom(image: image)
        return scan(document: doc)
    }
    
    func scan(document: ReceiptDocument) -> Observable<Scan> {
        guard let url = document.localURL else { return Observable<Scan>.just(Scan(image: UIImage())) }
        
        if WBPreferences.automaticScansEnabled() && FeatureFlags.ocrSupport.isEnabled &&
            authService.isLoggedIn && scansPurchaseTracker.hasAvailableScans {
            pushNotificationService.updateToken()
            statusSubject.onNext(.uploading)
            
            return scanFrom(uploading: s3Service.upload(file: url), document: document)
        } else {
            let isFeatureEnabled = "isFeatureEnabled = \(FeatureFlags.ocrSupport.isEnabled)"
            let isLoggedIn = "isLoggedIn = \(AuthService.shared.isLoggedIn)"
            let hasAvailableScans = "hasAvailableScans = \(ScansPurchaseTracker.shared.hasAvailableScans)"
            let authScansEabled = "authScansEabled = \(ScansPurchaseTracker.shared.hasAvailableScans)"
            Logger.debug("Ignoring OCR: \(isFeatureEnabled), \(isLoggedIn), \(hasAvailableScans), \(authScansEabled).")
            statusSubject.onNext(.completed)
            
            return Observable.just(Scan(filepath: document.localURL!))
        }
    }
    
    private func scanFrom(uploading: Observable<URL>, document: ReceiptDocument) -> Observable<Scan> {
        return uploading
            .do(onSubscribed: { AnalyticsManager.sharedManager.record(event: Event.ocrRequestStarted()) })
            .do(onError: { _ in
                _ = AuthService.shared.getUser().subscribe(onNext: { CognitoService().saveCognitoData(user: $0) })
            }).flatMap({ [weak self] url -> Observable<String> in
                guard let api = self?.recognitionAPI else {
                    self?.statusSubject.onNext(.completed)
                    return Observable<String>.never()
                }
                self?.statusSubject.onNext(.scanning)
                return api.recognize(url: url, incognito: !WBPreferences.allowSaveImageForAccuracy())
            }).flatMap({ [weak self] id -> Observable<String> in
                if let recognition = self?.getRecognitionID(id: id) { return recognition }
                return Observable.just(id)
            }).flatMap({ [weak self] id -> Observable<Scan> in
                guard let api = self?.recognitionAPI else { return Observable<Scan>.never() }
                self?.statusSubject.onNext(.fetching)
                return api.getRecognition(id)
                    .timeout(NETWORK_TIMEOUT, scheduler: MainScheduler.instance)
                    .do(onError: { error in
                        AnalyticsManager.sharedManager.record(event: Event.ocrRequestFailed())
                        AnalyticsManager.sharedManager.record(event: ErrorEvent(error: error))
                    }).map({ Scan(json: $0, filepath: document.localURL!) })
                    .do(onNext: { [weak self] _ in
                        self?.statusSubject.onNext(.completed)
                        AnalyticsManager.sharedManager.record(event: Event.ocrRequestSucceeded())
                        ScansPurchaseTracker.shared.decrementRemainingScans()
                    })
            }).catchError({ error -> Observable<Scan> in
                return Observable<Scan>.just(Scan(filepath: document.localURL!))
            })
    }
    
    private func getRecognitionID(id: String) -> Observable<String> {
        guard let pushService = self.pushNotificationService else { return Observable<String>.never() }
        
        let recognitionByPush = pushService.notificationJSON
            .map({ return $0.dictionaryValue[RECOGNITION_KEY]?["id"].string ?? id })
            .do(onNext: { _ in
                AnalyticsManager.sharedManager.record(event: Event.ocrPushMessageReceived())
            })
        
        let recognitionByTimeOut = Observable.just(id)
            .delay(PUSH_TIMEOUT, scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                AnalyticsManager.sharedManager.record(event: Event.ocrPushMessageTimeOut())
            })

        return Observable.of(recognitionByPush, recognitionByTimeOut)
            .merge()
            .take(1)
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
