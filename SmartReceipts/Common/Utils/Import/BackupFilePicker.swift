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
    
    fileprivate var urlSubject: PublishSubject<URL>?
    
    private lazy var filesViewController: UIViewController = {
        let fvc = UIDocumentPickerViewController(documentTypes: ALLOWED_TYPES, in: .open)
        fvc.delegate = self
        return fvc
    }()
    
    private override init() {}

    func openFilePicker(on viewController: UIViewController) -> Observable<URL> {
        self.urlSubject = .init()
        UINavigationBar.appearance().tintColor = AppTheme.primaryColor
        viewController.present(filesViewController, animated: true, completion: nil)
        return urlSubject!.asObservable()
    }
    
    private func close(completion: VoidBlock? = nil) {
        filesViewController.dismiss(animated: true, completion: completion)
    }
}

extension BackupFilePicker: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        AppTheme.customizeOnAppLoad()
        close { BackupDocument(fileURL: url).open() }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        AppTheme.customizeOnAppLoad()
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

