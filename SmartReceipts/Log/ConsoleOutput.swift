//
//  ConsoleOutput.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

public class ConsoleOutput: LogOutput {
    public init() {
        
    }
    
    public func printMessage(message: String) {
        print(message)
    }
}