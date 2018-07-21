//
//  ReceiptActionsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class ReceiptActionsInteractor: Interactor {
    
    func attachAppInputFile(to receipt: WBReceipt) -> Bool {
        let result = processAttachFile(to: receipt)
        AppDelegate.instance.freeFilePathToAttach()
        return result
    }
    
    func attachImage(_ image: UIImage, to receipt: WBReceipt) -> Bool {
        let imageFileName = String(format: "%tu_%@.jpg", receipt.receiptId(), receipt.omittedName)
        let path = receipt.trip.file(inDirectoryPath: imageFileName)
        if !FileManager.forceWrite(data: UIImageJPEGRepresentation(image, kImageCompression)!, to: path!) {
            return false
        }
        
        if !Database.sharedInstance().update(receipt, changeFileNameTo: imageFileName) {
            Logger.error("Error: cannot update image file")
            return false
        } else {
            SyncService.shared.uploadFile(receipt: receipt)
        }
        return true
    }
    
    private func processAttachFile(to receipt: WBReceipt) -> Bool {
        let file = AppDelegate.instance.filePathToAttach!
        let ext = file.asNSString.pathExtension
        
        let imageFileName = String(format: "%tu_%@.%@", receipt.receiptId(), receipt.omittedName, ext)
        let newFile = receipt.trip.file(inDirectoryPath: imageFileName)
        
        if !FileManager.forceCopy(from: file, to: newFile!) {
            Logger.error("Couldn't force copy from \(file) to \(newFile!)")
            return false
        }
        
        if !Database.sharedInstance().update(receipt, changeFileNameTo: imageFileName) {
            Logger.error("Error: cannot update image file \(imageFileName) for receipt \(receipt.name)")
            return false
        } else {
            SyncService.shared.uploadFile(receipt: receipt)
        }
        return true
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptActionsInteractor {
    var presenter: ReceiptActionsPresenter {
        return _presenter as! ReceiptActionsPresenter
    }
}
