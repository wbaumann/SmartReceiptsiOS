//
//  BackupFilePicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift

fileprivate let SMR_TYPE = "wb.smartreceipts.smr"

class BackupFilePicker: NSObject {
    static let sharedInstance = BackupFilePicker()
    fileprivate var filesViewController: UIViewController!
    fileprivate let urlSubject = PublishSubject<URL>()
    
    private override init() {}
    
    private let allowedTypes = [SMR_TYPE]
    
    func openFilePicker(on viewController: UIViewController) -> Observable<URL> {
        if #available(iOS 11.0, *) {
            let fvc = FilesViewController(forOpeningFilesWithContentTypes: allowedTypes)
            fvc.delegate = self
            filesViewController = fvc
            viewController.present(fvc, animated: true, completion: nil)
        }
        return urlSubject.asObservable()
    }
    
    fileprivate func close(completion: VoidBlock? = nil) {
        filesViewController.dismiss(animated: true, completion: completion)
    }
}

extension BackupFilePicker: UIDocumentBrowserViewControllerDelegate {
    @available(iOS 11.0, *)
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        if let url = documentURLs.first {
            close(completion: {
                BackupDocument(fileURL: url).open()
            })
        }
    }
}


fileprivate class BackupDocument: UIDocument {

    static let SMR_TEMP_NAME = "smr_temp.smr"
    static var smrTempURL: URL { return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(SMR_TEMP_NAME)! }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else { return }
        try? data.write(to: BackupDocument.smrTempURL)
        BackupFilePicker.sharedInstance.urlSubject.onNext(BackupDocument.smrTempURL)
    }
}

