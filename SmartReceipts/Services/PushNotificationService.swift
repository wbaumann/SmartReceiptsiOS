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
    
    override init() {}
    static let shared = PushNotificationService()
    
    var token: String? { return Messaging.messaging().fcmToken }
    
    func initialize() {
        Messaging.messaging().delegate = self
        
        AuthService.shared.loggedInObservable
            .filter({ $0 })
            .subscribe(onNext: { _ in
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current()
                    .requestAuthorization( options: [.badge], completionHandler: {_, _ in })
                UIApplication.shared.registerForRemoteNotifications()
                
                if let token = Messaging.messaging().fcmToken {
                    Logger.debug("FCM Token: \(token)")
                    self.saveDevice(token: token)
                }
            }).disposed(by: bag)
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
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        Logger.debug("FCM Token updated: \(fcmToken)")
        if AuthService.shared.isLoggedIn {
            saveDevice(token: fcmToken)
        }
    }
}

extension Reactive where Base: PushNotificationService {
    var notificationJSON: Observable<JSON> {
        return base.notificationSubject.asObservable()
    }
}
