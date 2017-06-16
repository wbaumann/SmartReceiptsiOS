//
//  ObservableTrips.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

fileprivate var _lastInstance: ObservableTrips?

class ObservableTrips: NSObject {

    private var array = [WBTrip]()
    var delegate: ObservableTripsDelegate?
    var count: Int { get { return array.count } }
    
    class var lastInstance: ObservableTrips? {
        get {
            return _lastInstance
        }
    }
    
    override init() {
        super.init()
        _lastInstance = self
    }
    
    func setTrips(_ trips: [WBTrip]) {
        array = trips
        delegate?.observableTrips(self, filledWithTrips: array)
    }
    
    func addTrip(_ trip: WBTrip) {
        let pos = findIndexFor(endDate: trip.endDate)
        array.insert(trip, at: pos)
        delegate?.observableTrips(self, addedTrip: trip, atIndex: pos)
    }
    
    func removeTrip(_ trip: WBTrip) {
        if let pos = array.index(of: trip) {
            array.remove(at: pos)
            delegate?.observableTrips(self, removedTrip: trip, atIndex: pos)
        }
    }
    
    func replace(trip: WBTrip, toTrip: WBTrip) {
        let oldPos = array.index(of: trip)!
        array.remove(at: oldPos)
        
        let newPos = array.index(of: toTrip)!
        array.remove(at: newPos)
        
        delegate?.observableTrips(self, replacedTrip: trip, toTrip: toTrip, fromIndex: oldPos, toIndex: newPos)
    }
    
    func findIndexFor(endDate: Date) -> Int {
        for i in 0..<count {
            if endDate.compare(array[i].endDate) != .orderedAscending {
                return i
            }
        }
        return count-1
    }
}


protocol ObservableTripsDelegate: class {
    func observableTrips(_ observableTrips: ObservableTrips, filledWithTrips: [WBTrip])
    func observableTrips(_ observableTrips: ObservableTrips, addedTrip: WBTrip, atIndex: Int)
    func observableTrips(_ observableTrips: ObservableTrips, replacedTrip: WBTrip, toTrip: WBTrip, fromIndex: Int, toIndex: Int)
    func observableTrips(_ observableTrips: ObservableTrips, removedTrip: WBTrip, atIndex: Int)
}
