//
//  PushNotificationService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
import FirebaseMessaging
import SwiftyJSON

class PushNotificationService: NSObject {
    fileprivate let notificationSubject = PublishSubject<JSON>()
    let bag = DisposeBag()
    static let shared = PushNotificationService()
    
    var token: String? { return Messaging.messaging().fcmToken }
    var notificationJSON: Observable<JSON> { return notificationSubject.asObservable() }
    
    override init() {}
    
    func initialize() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        AuthService.shared.loggedInObservable
            .filter({ $0 })
            .subscribe(onNext: { _ in
                if let token = Messaging.messaging().fcmToken {
                    Logger.debug("FCM Token: \(token)")
                    self.saveDevice(token: token)
                }
            }).disposed(by: bag)

    }
    
    func requestAuthorization() -> Observable<Void> {
        return Observable<Void>.create({ observer -> Disposable in
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { _,_  in
                observer.onNext(())
                observer.onCompleted()
            }
            UIApplication.shared.registerForRemoteNotifications()
            return Disposables.create()
        }).subscribeOn(MainScheduler.instance)
    }
    
    func authorizationStatus() -> Observable<UNAuthorizationStatus> {
        return notificationSettings()
            .map({ $0.authorizationStatus })
    }
    
    func notificationSettings() -> Observable<UNNotificationSettings> {
        return Observable<UNNotificationSettings>.create({ observer -> Disposable in
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                observer.onNext(settings)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func updateToken() {
        if let token = self.token {
            saveDevice(token: token)
        }
    }
    
    fileprivate func saveDevice(token: String) {
        AuthService.shared.saveDevice(token: token)
            .subscribe(onNext: {
                Logger.debug("FCM Token uploaded")
            }, onError: { error in
                Logger.error("Token Upload Error: \(error.localizedDescription))")
            }).disposed(by: bag)
    }
}

extension PushNotificationService: UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let data = notification.request.content.userInfo["gcm.notification.data"] {
            let notificationJSON = JSON(data)
            Logger.debug(notificationJSON.description)
            notificationSubject.onNext(notificationJSON)
        }
    }
    
    @nonobjc func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        Logger.debug("FCM Token updated: \(fcmToken)")
        if AuthService.shared.isLoggedIn {
            saveDevice(token: fcmToken)
        }
    }
}
