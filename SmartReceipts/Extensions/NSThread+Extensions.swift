//
//  NSThread+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension Thread {
    class func cachedObject<T>(_ type: T.Type, key: String) -> T? {
        return Thread.current.threadDictionary[key] as? T
    }
    
    class func cacheObject(_ object: AnyObject, key: String) {
        Thread.current.threadDictionary[key] = object
    }
}
