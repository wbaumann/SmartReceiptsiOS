//
//  ReceiptActionSheet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15.12.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

enum ReceiptAction {
    case edit, attachImage, move, copy, swapUp, swapDown, delete
}

class ReceiptActionSheet {
    private let receipt: WBReceipt
    
    init(receipt: WBReceipt) {
        self.receipt = receipt
    }
    
    func show() -> Observable<ReceiptAction> {
        let actionSheet = ActionSheet()
        defer { actionSheet.show() }
        
        var actions: [Observable<ReceiptAction>] = []
        
        actions.append(actionSheet.addAction(title: LocalizedString("DIALOG_RECEIPTMENU_TITLE_EDIT"), image: #imageLiteral(resourceName: "edit")).map { .edit })
        
        if AppDelegate.instance.filePathToAttach != nil {
            actions.append(actionSheet.addAction(title: handleAttachTitle(), image: #imageLiteral(resourceName: "attach")).map { .attachImage })
        }
        
        actions.append(actionSheet.addAction(title: LocalizedString("move"), image: #imageLiteral(resourceName: "move")).map { .move })
        actions.append(actionSheet.addAction(title: LocalizedString("copy"), image: #imageLiteral(resourceName: "copy")).map { .copy })
        actions.append(actionSheet.addAction(title: LocalizedString("receipt_dialog_action_swap_up"), image: #imageLiteral(resourceName: "arrow_up")).map { .swapUp })
        actions.append(actionSheet.addAction(title: LocalizedString("receipt_dialog_action_swap_down"), image: #imageLiteral(resourceName: "arrow_down")).map { .swapDown })
        actions.append(actionSheet.addAction(title: LocalizedString("delete"), image: #imageLiteral(resourceName: "delete-icon"), style: .destructive).map { .delete })
        
        return Observable.merge(actions).do(onNext: { [weak self] in self?.sendAnalytics(action: $0) })
    }
    
    private func sendAnalytics(action: ReceiptAction) {
        Logger.info("Selected Action: \(action)")
        switch action {
        case .edit: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuEdit())
        case .swapUp: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuSwapUp())
        case .swapDown: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuSwapDown())
        case .move, .copy: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuMoveCopy())
        case .delete: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuDelete())
        case .attachImage: AnalyticsManager.sharedManager.record(event: Event.receiptsImportPictureReceipt())
        }
    }
    
    private func handleAttachTitle() -> String {
        switch receipt.attachemntType {
        case .image: return String(format: LocalizedString("action_send_replace"), LocalizedString("image"))
        case .pdf: return String(format: LocalizedString("action_send_replace"), LocalizedString("pdf"))
        case .none:
            return AppDelegate.instance.isFileImage
                ? String(format: LocalizedString("action_send_attach"), LocalizedString("image"))
                : String(format: LocalizedString("action_send_attach"), LocalizedString("pdf"))
        }
    }
}
