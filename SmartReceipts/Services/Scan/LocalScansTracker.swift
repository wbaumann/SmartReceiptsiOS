//
//  LocalScansTracker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa

fileprivate let KEY_AVAILABLE_SCANS = "key_int_available_ocr_scans"

class LocalScansTracker: NSObject {
    static let shared = LocalScansTracker()
    
    fileprivate let availableScans = BehaviorRelay<Int>(value: 0)
    
    private override init() {
        availableScans.accept(UserDefaults.standard.integer(forKey: KEY_AVAILABLE_SCANS))
    }
    
    var scansCount: Int {
        get { return UserDefaults.standard.integer(forKey: KEY_AVAILABLE_SCANS) }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_AVAILABLE_SCANS)
            availableScans.accept(newValue)
        }
    }
}

extension Reactive where Base: LocalScansTracker {
    var scansCount: Observable<Int> {
        return base.availableScans.asObservable()
    }
}
