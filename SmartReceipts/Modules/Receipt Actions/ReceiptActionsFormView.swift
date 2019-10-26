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
    private let VIEW_IMAGE_ROW = "ViewImageRow"
    
    let actionSubject = PublishSubject<ReceiptAction>()
    
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
        <<< buttonRow(title: LocalizedString("DIALOG_RECEIPTMENU_TITLE_EDIT"), action: .edit)
            
        <<< buttonRow(title: handleAttachTitle(), action: .attachImage,
              condition: Condition.function([], { _ in
                AppDelegate.instance.filePathToAttach == nil
              }))
    
        <<< buttonRow(tag: VIEW_IMAGE_ROW, title: viewButtonTitle(), action: .viewImage,
          condition: Condition.function([], { [unowned self] _ in
            self.attachmentType == .none
          }))
    
        <<< buttonRow(tag: TAKE_IMAGE_ROW, title: takeImageTitle(), action: .importImage)
        <<< buttonRow(title: LocalizedString("move"), action: .move)
        <<< buttonRow(title: LocalizedString("copy"), action: .copy)
        <<< buttonRow(title: LocalizedString("receipt_dialog_action_swap_up"), action: .swapUp)
        <<< buttonRow(title: LocalizedString("receipt_dialog_action_swap_down"), action: .swapDown)
        
    }
    
    func update() {
        form.allRows.forEach { $0.evaluateHidden() }
        
        let takeImageRow = form.rowBy(tag: TAKE_IMAGE_ROW)
        takeImageRow?.title = takeImageTitle()
        takeImageRow?.reload()
        
        let viewImageRow = form.rowBy(tag: VIEW_IMAGE_ROW)
        viewImageRow?.title = viewButtonTitle()
        viewImageRow?.reload()
    }
    
    private func takeImageTitle() -> String {
        return attachmentType == .none ?
            LocalizedString("receipt_dialog_action_camera") :
            LocalizedString("menu_receiptimage_retake")
    }
    
    private func viewButtonTitle() -> String {
        var result = ""
        if attachmentType == .image {
            result = String(format: LocalizedString("receipt_dialog_action_view"), LocalizedString("image"))
        } else if attachmentType == .pdf {
            result = String(format: LocalizedString("receipt_dialog_action_view"), LocalizedString("pdf"))
        }
        return result
    }
    
    private func handleAttachTitle() -> String {
        let isFileImage = AppDelegate.instance.isFileImage
        var btnTitle = ""
        switch attachmentType {
        case .image:
            btnTitle = String(format: LocalizedString("action_send_replace"), LocalizedString("image"))
        case .pdf:
            btnTitle = String(format: LocalizedString("action_send_replace"), LocalizedString("pdf"))
        case .none:
            btnTitle = isFileImage ?
                String(format: LocalizedString("action_send_attach"), LocalizedString("image")) :
                String(format: LocalizedString("action_send_attach"), LocalizedString("pdf"))
        }
        return btnTitle
    }
    
    func buttonRow(tag: String? = nil, title: String, action: ReceiptAction, condition: Condition? = nil) -> ButtonRow {
        return
            ButtonRow(tag) { row in
                row.title = title
                row.hidden = condition
            }.onCellSelection({ [weak self] _, _ in
                self?.actionSubject.onNext(action)
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
            }).cellSetup({ cell, _ in
                cell.tintColor = .black
            })
    }
}


