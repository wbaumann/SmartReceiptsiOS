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
    
    weak var handleAttachTap: PublishSubject<Void>!
    weak var takeImageTap: PublishSubject<Void>!
    weak var retakeImageTap: PublishSubject<Void>!
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
        <<< buttonRow(title: handleAttachTitle(), bindSubject: handleAttachTap,
                     hidden: WBAppDelegate.instance().filePathToAttach == nil)
        <<< buttonRow(title: viewButtonTitle(), bindSubject: viewImageTap,
                     hidden: attachmentType == .none)
        <<< buttonRow(title: attachmentType == .none ? LocalizedString("receipt.action.take.receipt.image") :
            LocalizedString("receipt.action.retake.receipt.image"),
                bindSubject: attachmentType == .none ? takeImageTap : retakeImageTap)

            
        <<< buttonRow(title: LocalizedString("receipt.action.move"), bindSubject: moveTap)
        <<< buttonRow(title: LocalizedString("receipt.action.copy"), bindSubject: copyTap)
        <<< buttonRow(title: LocalizedString("receipt.action.swap.up"), bindSubject: swapUpTap)
        <<< buttonRow(title: LocalizedString("receipt.action.swap.down"), bindSubject: swapDownTap)
        
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
        let isFileImage = WBAppDelegate.instance().isFileImage
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


fileprivate func buttonRow(title: String, bindSubject: PublishSubject<Void>, hidden: Bool = false) -> ButtonRow {
    return
        ButtonRow() { row in
            row.title = title
            row.hidden = Condition(booleanLiteral: hidden)
        }.onCellSelection({ _, _ in
            bindSubject.onNext()
        }).cellUpdate({ cell, row in
            cell.textLabel?.textAlignment = .left
        }).cellSetup({ cell, _ in
            cell.tintColor = UIColor.black
        })
}
