//
//  MatchableExtensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import Cuckoo

extension WBReceipt: Matchable {
    public var matcher: ParameterMatcher<WBReceipt> {
        get {
            return ParameterMatcher(matchesFunction: { receipt -> Bool in
                return self.isEqual(receipt)
            })
        }
    }
}

extension UIImage: Matchable {
    public var matcher: ParameterMatcher<UIImage> {
        get {
            return ParameterMatcher(matchesFunction: { image -> Bool in
                return self.isEqual(image)
            })
        }
    }
}

extension WBTrip: Matchable {
    public var matcher: ParameterMatcher<WBTrip> {
        get {
            return ParameterMatcher(matchesFunction: { trip -> Bool in
                return self.isEqual(trip)
            })
        }
    }
}

extension Distance: Matchable {
    public var matcher: ParameterMatcher<Distance> {
        get {
            return ParameterMatcher(matchesFunction: { distance -> Bool in
                return self.objectId == distance.objectId
            })
        }
    }
}
