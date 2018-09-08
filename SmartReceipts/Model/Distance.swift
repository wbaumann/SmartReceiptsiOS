//
//  Distance.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 17/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

@objcMembers
class Distance: NSObject, NSCopying, FetchedModel {
    private var objId = 0
    var trip: WBTrip!
    var distance: NSDecimalNumber!
    var rate: Price!
    var location: String!
    var date: Date!
    var timeZone: TimeZone!
    var comment: String?
    var lastLocalModificationTime: Date!
    
    var objectId: Int {
        get { return objId }
        set { objId = newValue }
    }
    
    required init(trip: WBTrip, distance: NSDecimalNumber, rate: Price,
                  location: String, date: Date, timeZone: TimeZone, comment: String?) {
        self.trip = trip
        self.distance = distance
        self.rate = rate
        self.location = location
        self.date = date
        self.timeZone = timeZone
        self.comment = comment
    }
    
    override required init() {
        super.init()
    }
    
    override var hash: Int { get { return NSNumber(value: objId).hash } }
    
    func totalRate() -> Price {
        let totalValue = distance.multiplying(by: rate.amount)
        return Price(amount: totalValue, currencyCode: rate.currency.code)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Distance {
            if other === self {
                return true
            }
            return objId == other.objId
        } else {
            return false
        }
    }
    
    override var description: String {
        get {
            var description = "<\(NSStringFromClass(Distance.self))"
            description += "id: \(self.objId)"
            description += ">"
            return description
        }
    }
        
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Distance(trip: trip, distance: distance, rate: rate,
                        location: location, date: date, timeZone: timeZone, comment: comment)
        copy.objId = objId
        copy.lastLocalModificationTime = lastLocalModificationTime
        return copy
    }
    
    func loadData(from resultSet: FMResultSet!) {
        objId = Int(resultSet.int(forColumn: DistanceTable.Column.Id))
        distance = NSDecimalNumber(orZero: resultSet.string(forColumn: DistanceTable.Column.Distance))
        let rateString = resultSet.string(forColumn: DistanceTable.Column.Rate)
        let currency = resultSet.string(forColumn: DistanceTable.Column.RateCurrency)
        rate = Price(amount: NSDecimalNumber(orZero: rateString), currencyCode: currency!)
        location = resultSet.string(forColumn: DistanceTable.Column.Location)
        let dateMilliseconds = resultSet.unsignedLongLongInt(forColumn: DistanceTable.Column.Date)
        date = NSDate(milliseconds: Int64(dateMilliseconds))! as Date
        let tzName = resultSet.string(forColumn: DistanceTable.Column.Timezone)
        timeZone = tzName != nil ? NSTimeZone(name: tzName!)! as TimeZone : TimeZone.current
        comment = resultSet.string(forColumn: DistanceTable.Column.Comment)
        
        let time = resultSet.longLongInt(forColumn: SyncStateColumns.LastLocalModificationTime)/1000
        lastLocalModificationTime = Date(timeIntervalSince1970: TimeInterval(time))
    }

}

