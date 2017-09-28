//
//  String+Extensions.swift
//  SmartReceipts
//
//  Created by Victor on 12/20/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension String {
    
    
    /// Truncates String to given langth
    ///
    /// - Parameter length: Result string will be limited to the given number of characters.
    /// If length is 0 or less - empty string will be returned
    /// - Returns: truncated string.
    func truncateToLength(_ length: Int) -> String {
        if length <= 0 {
            // returns empty string
            return ""
        } else if length < self.characters.count {
            let endIndex = self.index(self.startIndex, offsetBy: length)
            let truncatedString = self.substring(to: endIndex)
            return truncatedString
        } else {
            return self
        }
    }
    
    
    /// Trims all special characters except the alphanumeric
    ///
    /// - Returns: resulting string
    func onlyAlphaNumeric() -> String {
        return self.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }
}

extension String {
    
    ///For placeholders
    static func randomAlphaNumericString(length: Int = 42) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }
}

extension String {
    mutating func appendIssue(_ issue: String) {
        if !self.isEmpty {
            self = self.appending("\n")
        }
        self = self.appending("\(LocalizedString("app.text.bullet.character")) \(issue)")
    }
    
    func isStringIgnoreCaseIn(array: [String]) -> Bool {
        for string in array {
            if string.caseInsensitiveCompare(self) == .orderedSame {
                return true
            }
        }
        return false
    }
}
