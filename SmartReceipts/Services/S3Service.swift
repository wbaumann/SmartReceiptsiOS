//
//  S3Service.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import AWSS3
import RxSwift

fileprivate let BUCKET = "smartreceipts"
fileprivate let FOLDER = "ocr/"
fileprivate let AMAZON_PREFIX = "https://s3.amazonaws.com/"

class S3Service {
    private var transferManager: AWSS3TransferManager!
    private var credentialsProvider: AWSCognitoCredentialsProvider!
    private let cognitoService = CognitoService()
    private let bag = DisposeBag()
    
    init() {
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityProvider: cognitoService)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        transferManager = AWSS3TransferManager.default()
        
        AuthService.shared.loggedInObservable
            .filter({ !$0 })
            .subscribe(onNext: { [weak self] _ in
                self?.credentialsProvider.clearCredentials()
            }).disposed(by: bag)
    }
    
    func upload(image: UIImage) -> Observable<URL> {
        if let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.jpg") {
            try? UIImagePNGRepresentation(image)?.write(to: imageURL)
            return upload(file: imageURL)
        }
        return Observable.error(NSError(domain: "temp.image.url.error", code: 1, userInfo: nil))
    }
    
    func upload(file url: URL) -> Observable<URL> {
        return Observable<URL>.create { [weak self] observer -> Disposable in
            if let sSelf = self {
                let key = FOLDER + UUID().uuidString + "_\(url.lastPathComponent)"
                let uploadRequest = AWSS3TransferManagerUploadRequest()
                uploadRequest?.bucket = BUCKET
                uploadRequest?.key = key
                uploadRequest?.body = url
                
                sSelf.transferManager.cancelAll()
                sSelf.transferManager.upload(uploadRequest!)
                    .continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
                    if let error = task.error  {
                        printError(error, operation: "Upload")
                        observer.onError(error)
                    } else {
                        Logger.debug("Upload complete for: \(uploadRequest!.key!)")
                        var resultURL = URL(string: AMAZON_PREFIX + BUCKET)
                        resultURL = resultURL!.appendingPathComponent(uploadRequest!.key!)
                        observer.onNext(resultURL!)
                        observer.onCompleted()
                    }
                    
                    return nil
                })
            }
            return Disposables.create()
        }
    }
    
    func downloadImage(_ url: URL, folder: String = FOLDER) -> Observable<UIImage> {
        return Observable<UIImage>.create { [weak self] observer -> Disposable in
            if let sSelf = self {
                let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent(url.lastPathComponent)
                
                let downloadRequest = AWSS3TransferManagerDownloadRequest()
                downloadRequest!.bucket = BUCKET
                downloadRequest!.key = folder + url.lastPathComponent
                downloadRequest!.downloadingFileURL = downloadingFileURL
                
                sSelf.transferManager.download(downloadRequest!)
                    .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                    if let error = task.error  {
                        printError(error, operation: "Download")
                        observer.onError(error)
                    } else {
                        Logger.debug("Download complete for: \(downloadRequest!.key!)")
                        let img = UIImage(data: try! Data(contentsOf: downloadingFileURL))
                        observer.onNext(img!)
                        observer.onCompleted()
                    }
                    return nil
                })
            }
            return Disposables.create()
        }
    }
}

fileprivate func printError(_ error: Error, operation: String) {
    if error.domain == AWSS3TransferManagerErrorDomain,
        let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
        switch code {
        case .cancelled, .paused:
            break
        default:
            Logger.error(operation + " Error: \(error)")
        }
    } else {
        Logger.error(operation + " Error: \(error)")
    }
}
