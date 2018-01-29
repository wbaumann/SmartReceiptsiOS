//
//  ReceiptActionsFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 21/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit
import Eureka
import RxCocoa
import RxSwift

class ReceiptActionsFormView: FormViewController {
    
    private let TAKE_IMAGE_ROW = "TakeImageRow"
    
    weak var editReceiptTap: PublishSubject<Void>!
    weak var handleAttachTap: PublishSubject<Void>!
    weak var takeImageTap: PublishSubject<Void>!
    weak var viewImageTap: PublishSubject<Void>!
    weak var moveTap: PublishSubject<Void>!
    weak var copyTap: PublishSubject<Void>!
    weak var swapUpTap: PublishSubject<Void>!
    weak var swapDownTap: PublishSubject<Void>!
    
    var attachmentType: ReceiptAttachmentType = .none
    
    required init(attachmentType: ReceiptAttachmentType) {
        super.init(nibName: nil, bundle: nil)
        self.attachmentType = attachmentType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
        <<< buttonRow(title: LocalizedString("receipt_action_edit_receipt"), bindSubject: editReceiptTap)
            
        <<< buttonRow(title: handleAttachTitle(), bindSubject: handleAttachTap,
                  condition: Condition.function([], { _ in
                    AppDelegate.instance.filePathToAttach == nil
                  }))
        
        <<< buttonRow(title: viewButtonTitle(), bindSubject: viewImageTap,
                  condition: Condition.function([], { [unowned self] _ in
                    self.attachmentType == .none
                  }))
        
        <<< buttonRow(tag: TAKE_IMAGE_ROW, title: takeImageTitle(), bindSubject: takeImageTap)
        <<< buttonRow(title: LocalizedString("receipt.action.move"), bindSubject: moveTap)
        <<< buttonRow(title: LocalizedString("receipt.action.copy"), bindSubject: copyTap)
        <<< buttonRow(title: LocalizedString("receipt.action.swap.up"), bindSubject: swapUpTap)
        <<< buttonRow(title: LocalizedString("receipt.action.swap.down"), bindSubject: swapDownTap)
        
    }
    
    func update() {
        form.allRows.forEach { $0.evaluateHidden() }
        
        let takeImageRow = form.rowBy(tag: TAKE_IMAGE_ROW)
        takeImageRow?.title = takeImageTitle()
        takeImageRow?.reload()
    }
    
    private func takeImageTitle() -> String {
        return attachmentType == .none ?
            LocalizedString("receipt.action.take.receipt.image") :
            LocalizedString("receipt.action.retake.receipt.image")
    }
    
    private func viewButtonTitle() -> String {
        var result = ""
        if attachmentType == .image || attachmentType == .none {
            result = LocalizedString("receipt.action.view.receipt.image")
        } else if attachmentType == .pdf {
            result = LocalizedString("receipt.action.view.receipt.pdf")
        }
        return result
    }
    
    private func handleAttachTitle() -> String {
        let isFileImage = AppDelegate.instance.isFileImage
        var btnTitle = ""
        switch attachmentType {
        case .image:
            btnTitle = isFileImage ?
                LocalizedString("receipt.action.replace.image") :
                LocalizedString("receipt.action.replace.image.with.pdf")
            
        case .pdf:
            btnTitle = isFileImage ?
                LocalizedString("receipt.action.replace.pdf.with.image") :
                LocalizedString("receipt.action.replace.pdf")
            
        case .none:
            btnTitle = isFileImage ?
                LocalizedString("receipt.action.attach.image") :
                LocalizedString("receipt.action.attach.pdf")
        }
        return btnTitle
    }
}

fileprivate func buttonRow(tag: String? = nil, title: String, bindSubject: PublishSubject<Void>, condition: Condition? = nil) -> ButtonRow {
    return
        ButtonRow(tag) { row in
            row.title = title
            row.hidden = condition
        }.onCellSelection({ [weak bindSubject] _, _ in
            bindSubject?.onNext()
        }).cellUpdate({ cell, row in
            cell.textLabel?.textAlignment = .left
        }).cellSetup({ cell, _ in
            cell.tintColor = UIColor.black
        })
}
