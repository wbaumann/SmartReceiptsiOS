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
                return true
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

extension PaymentMethod: Matchable {
    public var matcher: ParameterMatcher<PaymentMethod> {
        get {
            return ParameterMatcher(matchesFunction: { method -> Bool in
                return self == method
            })
        }
    }
}

extension WBCategory: Matchable {
    public var matcher: ParameterMatcher<WBCategory> {
        get {
            return ParameterMatcher(matchesFunction: { category -> Bool in
                return self == category
            })
        }
    }
}

// MARK: Array<Column> : Matchable
extension Array: Matchable {
    public var matcher: ParameterMatcher<Array<Column>> {
        get {
            return ParameterMatcher(matchesFunction: { columns -> Bool in
                var matched = false
                if self.count == columns.count && Element.self == Column.self {
                    for i in 0..<self.count {
                        if (self[i] as! Column).matcher.matches(columns[i]) {
                            continue
                        }
                        return false
                    }
                    matched = true
                }
                return matched
            })
        }
    }
}

extension Column: Matchable {
    public var matcher: ParameterMatcher<Column> {
        get {
            return ParameterMatcher(matchesFunction: { column -> Bool in
                return self.name == column.name
            })
        }
    }
}

extension Credentials: Matchable {
    public var matcher: ParameterMatcher<Credentials> {
        get {
            return ParameterMatcher(matchesFunction: { credentials -> Bool in
                return credentials.email == self.email && credentials.password == self.password
            })
        }
    }
}

extension URL: Matchable {
    public var matcher: ParameterMatcher<URL> {
        get {
            return ParameterMatcher(matchesFunction: { url -> Bool in
                return self == url
            })
        }
    }
}
