//
//  NSThread+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension NSThread {
    class func cachedObject<T>(type: T.Type, key: String) -> T? {
        return NSThread.currentThread().threadDictionary[key] as? T
    }
    
    class func cacheObject(object: AnyObject, key: String) {
        NSThread.currentThread().threadDictionary[key] = object
    }
}