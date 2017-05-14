//
//  RecentCurrenciesCache.swift
//  SmartReceipts
//
//  Created by Victor on 4/12/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

/// Recently used currencies cache
class RecentCurrenciesCache: NSObject {
    
    static let shared = RecentCurrenciesCache()
    
    /// Recent currencies (codes)
    var cachedCurrencyCodes: [String] {
        return cachedCurrencies.map{ $0.code }
    }
    
    /// Recent currencies
    private(set) var cachedCurrencies: [WBCurrency] {
        get {
            var cached: [WBCurrency]?
            if let unarchivedData = cache.object(forKey: currenciesKey) {
                cached = NSKeyedUnarchiver.unarchiveObject(with: unarchivedData as Data) as? Array<WBCurrency>
            }
            return cached ?? []
        }
        set {
            let archivedData = NSKeyedArchiver.archivedData(withRootObject: newValue) as NSData
            cache.setObject(archivedData, forKey: currenciesKey)
        }
    }
    
    private let cache = NSCache<NSString, NSData>()
    private let currenciesKey: NSString = "RecentCurrenciesCache_cachedCurrencies"
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name.DatabaseDidInsertModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name.DatabaseDidDeleteModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name.DatabaseDidUpdateModel, object: nil)
    }
    
    /// Force reload
    func update() {
        /// read FMDB queue from global_dispatch queue
        DispatchQueue.global(qos: .default).async {
            let fetched = Database.sharedInstance().recentCurrencies()
            DispatchQueue.main.async {
                self.cachedCurrencies = fetched ?? []
            }
        }
    }
    
    // MARK: - Test
    
    /// For unit tests only (as we don't want to expose cachedCurrencies setter)
    func updateInDatabase(database: Database) {
        self.cachedCurrencies = database.recentCurrencies()
    }
    
}
