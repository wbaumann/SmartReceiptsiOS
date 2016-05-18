//
//  Constants.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

func onMainThread(closure: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), closure)
}