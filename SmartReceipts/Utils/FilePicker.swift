//
//  FilePicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 20/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift

fileprivate let JPEG_TYPE = "public.jpeg"
fileprivate let PNG_TYPE = "public.png"
fileprivate let PDF_TYPE = "com.adobe.pdf"

class ReceiptFilePicker: NSObject {
    static let sharedInstance = ReceiptFilePicker()
    fileprivate var pickSubject: PublishSubject<ReceiptDocument>?
    fileprivate var openedViewController: UIViewController?
    
    private let allowedTypes = [JPEG_TYPE, PNG_TYPE, PDF_TYPE]
    
    private override init() {}
    
    func openFilePicker(on viewController: UIViewController) -> Observable<ReceiptDocument> {
        pickSubject = PublishSubject<ReceiptDocument>()
        if #available(iOS 11.0, *) {
            let title = LocalizedString("receipt_import_action_sheet_title")
            let actionFilesTitle = LocalizedString("receipt_import_action_files")
            let actionCameraRollTitle = LocalizedString("receipt_import_action_camera_roll")
            
            let actionSheet = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: actionCameraRollTitle, style: .default, handler: { _ in
                self.openedViewController = self.imagePicker()
                self.openPicker(on: viewController)
            }))
            
            actionSheet.addAction(UIAlertAction(title: actionFilesTitle, style: .default, handler: { _ in
                let bvc = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: self.allowedTypes)
                bvc.delegate = self
                self.openedViewController = bvc
                self.openPicker(on: viewController)
            }))
            
            
            viewController.present(actionSheet, animated: true, completion: nil)
            
        } else {
            openedViewController = imagePicker()
            openPicker(on: viewController)
        }
        return pickSubject!.asObservable()
    }
    
    private func openPicker(on viewController: UIViewController){
        UINavigationBar.appearance().barTintColor = AppTheme.primaryColor
        viewController.present(openedViewController!, animated: true, completion: nil)
    }
    
    private func imagePicker() -> UIImagePickerController {
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        return ipc
    }
    
    fileprivate func close(completion: VoidBlock? = nil) {
        UINavigationBar.appearance().barTintColor = .white
        openedViewController?.dismiss(animated: true, completion: completion)
    }
}



extension ReceiptFilePicker: UIDocumentBrowserViewControllerDelegate {
    @available(iOS 11.0, *)
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        let url = documentURLs.first!
        
        close(completion: {
            ReceiptDocument(fileURL: url).open()
        })
    }
}

extension ReceiptFilePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let img = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        var resultImage = WBImageUtils.compressImage(img, withRatio: 0.95)
        resultImage = WBImageUtils.processImage(resultImage)
        
        close(completion: {
            let imgData = UIImageJPEGRepresentation(resultImage!, 1)!
            try? imgData.write(to: ReceiptDocument.imgTempURL)
            let doc = ReceiptDocument(fileURL: ReceiptDocument.imgTempURL)
            try? doc.load(fromContents: imgData, ofType: JPEG_TYPE)
        })
    }
}


class ReceiptDocument: UIDocument {
    var image: UIImage?
    var rawData: Data?
    var localURL: URL?
    
    static let PDF_TEMP_NAME = "pdf_temp.pdf"
    static let IMG_TEMP_NAME = "img_temp.pdf"
    
    static var pdfTempURL: URL { return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(PDF_TEMP_NAME)! }
    static var imgTempURL: URL { return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(IMG_TEMP_NAME)! }
    
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data, let fileType = typeName else { return }
        rawData = data
        
        if fileType == PNG_TYPE || fileType == JPEG_TYPE {
            image = UIImage(data: data)
            localURL = ReceiptDocument.imgTempURL
        } else if fileType == PDF_TYPE {
            let imageDataProvider = CGDataProvider(data: data as CFData)!
            let doc = CGPDFDocument(imageDataProvider)
            let pdfPage = doc?.page(at: 1)
            var pageRect: CGRect = pdfPage!.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)

            UIGraphicsBeginImageContext(pageRect.size)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(pdfPage!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage!)
            context.restoreGState()
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            localURL = ReceiptDocument.pdfTempURL
            try? data.write(to: ReceiptDocument.pdfTempURL)
        }
        
        ReceiptFilePicker.sharedInstance.pickSubject?.onNext(self)
    }
}
