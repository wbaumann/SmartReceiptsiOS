//
//  Constants.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

let MIGRATION_VERSION = 1
let TOUCH_AREA: CGFloat = 44

let UI_MARGIN_8: CGFloat = 8
let UI_MARGIN_16: CGFloat = 16

let DEFAULT_ANIMATION_DURATION = 0.3
let VIEW_CONTROLLER_TRANSITION_DELAY = 0.6

func onMainThread(_ closure: @escaping VoidBlock) {
    DispatchQueue.main.async(execute: closure)
}

func timeMeasured(_ desc: String = "", closure: () -> ()) {
    let start = CACurrentMediaTime()
    closure()
    Logger.debug(String(format: "%@ - time: %f", desc, CACurrentMediaTime() - start))
}

func delayedExecution(_ afterSecons: TimeInterval, closure: @escaping () -> ()) {
    let delayTime = DispatchTime.now() + Double(Int64(afterSecons * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: closure)
}

func LocalizedString(_ key: String, comment: String = "") -> String {
    var result = NSLocalizedString(key, tableName: nil, comment: comment)
    if result == key {
        result = NSLocalizedString(key, tableName: "SharedLocalizable", comment: comment)
    }
    return result
}

func MainStoryboard() -> UIStoryboard {
    return UI_USER_INTERFACE_IDIOM() == .pad ?
        UIStoryboard(name: "MainStoryboard_iPad", bundle: nil) :
        UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil)
}

func executeFor(iPhone: ()->(), iPad: ()->()) {
    UI_USER_INTERFACE_IDIOM() == .pad ? iPad() : iPhone()
}

func screenScaled(_ value: CGFloat) -> CGFloat {
    return value * ((1.0/667.0) * UIScreen.main.bounds.height)
}

enum ReceiptAttachmentType {
    case image
    case pdf
    case none
}
