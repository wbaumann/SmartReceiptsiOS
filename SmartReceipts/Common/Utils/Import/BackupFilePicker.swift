//
//  BackupFilePicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift

private let SMR_TYPE = "wb.smartreceipts.smr"
private let ALLOWED_TYPES = [SMR_TYPE]

class BackupFilePicker: NSObject {
    static let sharedInstance = BackupFilePicker()
    private var filesViewController: UIViewController!
    fileprivate var urlSubject: PublishSubject<URL>?
    
    private override init() {}

    func openFilePicker(on viewController: UIViewController) -> Observable<URL> {
        self.urlSubject = .init()
        
        if #available(iOS 11.0, *) {
            if filesViewController == nil {
                let fvc = FilesViewController(forOpeningFilesWithContentTypes: ALLOWED_TYPES)
                fvc.delegate = self
                filesViewController = fvc
            }
            viewController.present(filesViewController, animated: true, completion: nil)
        } else {
            Logger.error("BackupFilePicker not available on iOS < 11.0")
        }
        
        return urlSubject!.asObservable()
    }
    
    private func close(completion: VoidBlock? = nil) {
        filesViewController.dismiss(animated: true, completion: completion)
    }
}

extension BackupFilePicker: UIDocumentBrowserViewControllerDelegate {
    @available(iOS 11.0, *)
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let url = documentURLs.first else { return }
        close { BackupDocument(fileURL: url).open() }
    }
}


fileprivate class BackupDocument: UIDocument {
    static let SMR_TEMP_NAME = "smr_temp.smr"
    static var smrTempURL: URL { return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(SMR_TEMP_NAME)! }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data, let subject = BackupFilePicker.sharedInstance.urlSubject else { return }
        try? data.write(to: BackupDocument.smrTempURL)
        subject.onNext(BackupDocument.smrTempURL)
    }
}

