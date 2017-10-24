//
//  LocalScansTracker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift

fileprivate let KEY_AVAILABLE_SCANS = "key_int_available_ocr_scans"

class LocalScansTracker: NSObject {
    static let shared = LocalScansTracker()
    
    fileprivate let availableScans = Variable<Int>(0)
    
    private override init() {
        availableScans.value = UserDefaults.standard.integer(forKey: KEY_AVAILABLE_SCANS)
    }
    
    var scansCount: Int {
        get { return UserDefaults.standard.integer(forKey: KEY_AVAILABLE_SCANS) }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_AVAILABLE_SCANS)
            availableScans.value = newValue
        }
    }
}

extension Reactive where Base: LocalScansTracker {
    var scansCount: Observable<Int> {
        return base.availableScans.asObservable()
    }
}
