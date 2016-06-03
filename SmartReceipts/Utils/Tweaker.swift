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
        Tweaker.usePurchaseOverride()
        Tweaker.subscriptionOverrideValue()
    }
    
    class func usePurchaseOverride() -> Bool {
        return tweakValueForCategory("Subscription", collectionName: "Purchase", name: "Use override", defaultValue: false).boolValue
    }
    
    class func subscriptionOverrideValue() -> Bool {
        let enabled = "enabled"
        let values = [
            enabled: "Subscription on",
            "disabled": "Subscription off"
        ]
        
        let tweaked = tweakValueForCategory("Subscription", collectionName: "Purchase", name: "Override", defaultValue: NSString(string: enabled), possibleValues: values)
        
        return enabled == tweaked
    }
    
    private class func collectionWithName(collectionName: String, categoryName: String) -> FBTweakCollection {
        let store = FBTweakStore.sharedInstance()
        
        var category = store.tweakCategoryWithName(categoryName)
        if category == nil {
            category = FBTweakCategory(name: categoryName)
            store.addTweakCategory(category)
        }
        
        var collection = category.tweakCollectionWithName(collectionName)
        if collection == nil {
            collection = FBTweakCollection(name: collectionName)
            category.addTweakCollection(collection)
        }
        return collection
    }
    
    private class func tweakValueForCategory<T:AnyObject>(categoryName: String, collectionName: String, name: String, defaultValue: T, possibleValues: [String: AnyObject]? = nil) -> T {
        
        let identifier = categoryName.lowercaseString + "." + collectionName.lowercaseString + "." + name
        
        let collection = collectionWithName(collectionName, categoryName: categoryName)
        
        var tweak = collection.tweakWithIdentifier(identifier)
        if tweak == nil {
            tweak = FBTweak(identifier: identifier)
            tweak.name = name
            tweak.defaultValue = defaultValue
            if let possible = possibleValues {
                tweak.possibleValues = possible
            }
            collection.addTweak(tweak)
        }
        
        return (tweak.currentValue ?? tweak.defaultValue) as! T
    }
}