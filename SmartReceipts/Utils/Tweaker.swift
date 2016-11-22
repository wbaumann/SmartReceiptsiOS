//
//  Tweaker.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 03/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import Tweaks

@objc class Tweaker: NSObject {
    class func preload() {
        _ = Tweaker.usePurchaseOverride()
        _ = Tweaker.subscriptionOverrideValue()
    }
    
    class func usePurchaseOverride() -> Bool {
        return tweakValueForCategory(categoryName: "Subscription", collectionName: "Purchase", name: "Use override", defaultValue: false) as Bool
    }
    
    class func subscriptionOverrideValue() -> Bool {
        let enabled = "enabled"
        let values: [String : String] = [
            enabled: "Subscription on",
            "disabled": "Subscription off"
        ]
        
        let tweaked = tweakValueForCategory(categoryName: "Subscription", collectionName: "Purchase", name: "Override", defaultValue: NSString(string: enabled), possibleValues: values) as String
        
        return enabled == tweaked
    }
    
    private class func collectionWithName(collectionName: String, categoryName: String) -> FBTweakCollection {
        let store = FBTweakStore.sharedInstance()!
        
        var category = store.tweakCategory(withName: categoryName)
        if category == nil {
            category = FBTweakCategory(name: categoryName)
            store.addTweakCategory(category)
        }
        
        var collection = category?.tweakCollection(withName: collectionName)
        if collection == nil {
            collection = FBTweakCollection(name: collectionName)
            category?.addTweakCollection(collection)
        }
        return collection!
    }
    
    private class func tweakValueForCategory<T:Any>(categoryName: String, collectionName: String, name: String, defaultValue: T, possibleValues: [String: Any]? = nil) -> T {
        
        let identifier = categoryName.lowercased() + "." + collectionName.lowercased() + "." + name
        
        let collection = collectionWithName(collectionName: collectionName, categoryName: categoryName)
        
        var tweak = collection.tweak(withIdentifier: identifier)
        if tweak == nil {
            tweak = FBTweak(identifier: identifier)
            tweak?.name = name
            tweak?.defaultValue = defaultValue
            if let possible = possibleValues {
                tweak?.possibleValues = possible
            }
            collection.addTweak(tweak)
        }
        
        return (tweak?.currentValue ?? defaultValue) as! T
    }
}
