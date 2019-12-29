//
//  FilePicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 20/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift
import Toaster

fileprivate let JPEG_TYPE = "public.jpeg"
fileprivate let PNG_TYPE = "public.png"
fileprivate let PDF_TYPE = "com.adobe.pdf"

class ReceiptFilePicker: NSObject {
    static let sharedInstance = ReceiptFilePicker()
    fileprivate var pickSubject: PublishSubject<ReceiptDocument>?
    fileprivate var openedViewController: UIViewController?
    var bag = DisposeBag()
    
    private let allowedTypes = [JPEG_TYPE, PNG_TYPE, PDF_TYPE]  //Temporarily disabled pdf imports from the "Files" screen for `Issue 5`
    
    private override init() {}
    
    func openFilePicker(on viewController: UIViewController) -> Observable<ReceiptDocument> {
        bag = DisposeBag()
        pickSubject = PublishSubject<ReceiptDocument>()
        if #available(iOS 11.0, *) {
            let sheet = ActionSheet()
            
            sheet.addAction(title: LocalizedString("receipt_import_action_camera_roll"), image: #imageLiteral(resourceName: "gallery"))
                .subscribe(onNext: { [weak self] _ in
                    self?.openedViewController = self?.imagePicker()
                    self?.openPicker(on: viewController)
                }).disposed(by: bag)
                
            sheet.addAction(title: LocalizedString("receipt_import_action_files"), image: #imageLiteral(resourceName: "file-plus"))
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    let fvc = UIDocumentPickerViewController(documentTypes: self.allowedTypes, in: .open)
                    fvc.delegate = self
                    UINavigationBar.appearance().tintColor = AppTheme.primaryColor
                    self.openedViewController = fvc
                    self.openPicker(on: viewController)
                }).disposed(by: bag)
                
            sheet.show()
        } else {
            openedViewController = imagePicker()
            openPicker(on: viewController)
        }
        return pickSubject!.asObservable()
    }
    
    private func openPicker(on viewController: UIViewController) {
        viewController.present(openedViewController!, animated: true, completion: nil)
    }
    
    private func imagePicker() -> UIImagePickerController {
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        return ipc
    }
}

extension ReceiptFilePicker: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        AppTheme.customizeOnAppLoad()
        openedViewController?.dismiss(animated: true, completion: nil)
        var document = ReceiptDocument(fileURL: url)
        guard let fileType = document.fileType else { return }
        if fileType == PNG_TYPE || fileType == JPEG_TYPE {
            if let data = try? Data(contentsOf: url), DataValidator().isValidImage(data: data) {
                let img = UIImage(data: data)
                let compressedImage = WBImageUtils.compressImage(img, withRatio: kImageCompression)
                let compressedURL = ReceiptDocument.makeDocumentFrom(image: compressedImage!).localURL!
                document = ReceiptDocument(fileURL: compressedURL)
            } else {
                self.emitImportError()
                return
            }
        } else if fileType == PDF_TYPE {
            if let data = try? Data(contentsOf: url), !DataValidator().isValidPDF(data: data) {
                self.emitImportError()
                return
            }
        }
        
        return document.open()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        AppTheme.customizeOnAppLoad()
    }
    
    private func emitImportError() {
        let errorInfo = [NSLocalizedDescriptionKey : LocalizedString("IMPORT_ERROR")]
        let error = NSError(domain: NSPOSIXErrorDomain, code: Int(EINVAL), userInfo: errorInfo)
        ReceiptFilePicker.sharedInstance.pickSubject?.onError(error)
    }
}

extension ReceiptFilePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info.image else { return }
        let resultImage = WBImageUtils.compressImage(img, withRatio: kImageCompression)
        openedViewController?.dismiss(animated: true, completion: {
            ReceiptDocument.makeDocumentFrom(image: resultImage!).open()
        })
    }
}


class ReceiptDocument: UIDocument {
    private(set) var rawData: Data?
    private(set) var localURL: URL?
    private(set) var isPDF = false
    
    static let PDF_TEMP_NAME = "pdf_temp.pdf"
    static let IMG_TEMP_NAME = "img_temp.jpg"
    
    static var pdfTempURL: URL { return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(PDF_TEMP_NAME)! }
    static var imgTempURL: URL { return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(IMG_TEMP_NAME)! }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data, let fileType = typeName else { return }
        forceLoad(data: data, fileType: fileType)
        ReceiptFilePicker.sharedInstance.pickSubject?.onNext(self)
    }
    
    fileprivate func forceLoad(data: Data, fileType: String) {
        rawData = data
        
        if fileType == PNG_TYPE || fileType == JPEG_TYPE {
            isPDF = false
            localURL = ReceiptDocument.imgTempURL
        } else if fileType == PDF_TYPE {
            isPDF = true
            localURL = ReceiptDocument.pdfTempURL
        }
        try? data.write(to: localURL!)
    }
    
    class func makeDocumentFrom(image: UIImage) -> ReceiptDocument {
        let img = WBImageUtils.processImage(image)!
        let imgWithoutScale = WBImageUtils.withoutScreenScale(img)!
        let imgData = imgWithoutScale.jpegData(compressionQuality: 1)!
        let doc = ReceiptDocument(fileURL: ReceiptDocument.imgTempURL)
        doc.forceLoad(data: imgData, fileType: JPEG_TYPE)
        return doc
    }
}
