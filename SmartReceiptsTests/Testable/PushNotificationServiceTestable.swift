//
//  PushNotificationServiceTestable.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxSwift

class PushNotificationServiceTestable: PushNotificationService {
    var notificationObservable: Observable<RecognitionNotification>!
    
    override var notification: Observable<RecognitionNotification> {
        return notificationObservable
    }
}
