//
//  DebugFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import RxCocoa
import Toaster

class DebugFormView: FormViewController {
    
    fileprivate let loginSubject = PublishSubject<Void>()
    fileprivate let testLoginSubject = PublishSubject<Void>()
    fileprivate let subscriptionSubject = PublishSubject<Bool>()
    private let s3Service = S3Service()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section("Modules")
        <<< ButtonRow() { row in
            row.title = "Auth Module"
        }.onCellSelection({ [unowned self] _ in
            self.loginSubject.onNext()
        })
        
            
        +++ Section("Flags")
        <<< SwitchRow() { row in
            row.title = "Subscription"
            row.value = DebugStates.subscription()
        }.onChange({ [unowned self] row in
            self.subscriptionSubject.onNext(row.value!)
        })
            
        <<< SwitchRow() { row in
            row.title = "Use Production endpoints"
            row.value = FeatureFlags.useProdEndpoints.isEnabled
        }.onChange({ row in
            FeatureFlags.useProdEndpoints = Feature(row.value!)
        })
        
        +++ Section("Amazon S3")
        <<< ButtonRow() {row in
            row.title = "Upload Test Image"
            row.cell.imageView?.image = #imageLiteral(resourceName: "launch_image")
        }.onCellSelection({ [unowned self] cell, row in
            if let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TestImage.jpg") {
                try? UIImagePNGRepresentation(#imageLiteral(resourceName: "launch_image"))?.write(to: imageURL)
                self.s3Service.upload(file: imageURL)
                    .flatMap({ url -> Observable<UIImage> in
                        return self.s3Service.downloadImage(url)
                    }).subscribe(onNext: { img in
                        
                    }, onError: {
                        Toast.show($0.localizedDescription)
                    }).disposed(by: self.bag)
            }
        }).cellSetup({ cell, row in
            cell.tintColor = AppTheme.primaryColor
        })
    }
    
}

extension Reactive where Base: DebugFormView  {
    var loginTap: Observable<Void> { return base.loginSubject }
    var subscriptionChange: Observable<Bool> { return base.subscriptionSubject }
    var testLoginTap: Observable<Void> { return base.testLoginSubject }
}
