//
//  PushNotificationServiceTestable.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxSwift
import SwiftyJSON

class PushNotificationServiceTestable: PushNotificationService {
    var notificationObservable: Observable<JSON>!
    override var notificationJSON: Observable<JSON> {
        return notificationObservable
    }
}
