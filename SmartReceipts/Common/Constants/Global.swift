//
//  Constants.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

let MIGRATION_VERSION = 2
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
    typealias OBJC_LocalizedString = LocalizedString
    return OBJC_LocalizedString.from(key, comment: comment)
}

func MainStoryboard() -> UIStoryboard {
    return  UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil)
}

func screenScaled(_ value: CGFloat) -> CGFloat {
    return value * ((1.0/667.0) * UIScreen.main.bounds.height)
}

enum ReceiptAttachmentType {
    case image
    case pdf
    case none
}

func ABSTRACT_METHOD() {
    preconditionFailure("ABSTRACT_METHOD")
}
