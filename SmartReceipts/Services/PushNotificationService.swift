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

class PushNotificationService: NSObject, UNUserNotificationCenterDelegate {
    let bag = DisposeBag()
    override init() {}
    static let shared = PushNotificationService()
    
    func initialize() {
        Messaging.messaging().delegate = self
        
        AuthService.shared.loggedInObservable
            .filter({ $0 })
            .subscribe(onNext: { _ in
                if #available(iOS 10.0, *) {
                    // For iOS 10 display notification (sent via APNS)
                    UNUserNotificationCenter.current().delegate = self
                    
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(
                        options: authOptions,
                        completionHandler: {_, _ in })
                } else {
                    let settings: UIUserNotificationSettings =
                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }
                UIApplication.shared.registerForRemoteNotifications()
            }).disposed(by: bag)
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
}

extension PushNotificationService: MessagingDelegate {
    func application(received remoteMessage: MessagingRemoteMessage) {
        Logger.debug("BE -> " + remoteMessage.appData.debugDescription)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        Logger.debug("BE2 -> " + remoteMessage.appData.debugDescription)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
}
