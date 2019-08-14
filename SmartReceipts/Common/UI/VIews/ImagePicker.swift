//
//  ImagePicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import AVKit

private let COMPRESSION_RATIO: CGFloat = 0.95

class ImagePicker: NSObject {
    static let shared = ImagePicker()
    private override init() {}
    
    private var singleObserver: ((SingleEvent<UIImage>) -> ())?
    
    private func result() -> Single<UIImage> {
        return .create(subscribe: { observer -> Disposable in
            self.singleObserver = observer
            return Disposables.create()
        })
    }
    
    //MARK: - Interface
    
    func presentPicker(on viewController: UIViewController) -> Single<UIImage> {
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        if !hasCamera {
            return presentPicker(on: viewController, source: .photoLibrary)
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(.init(title: LocalizedString("receipt_attach_photo"), style: .default) { [weak self] _ in
            self?.presentPicker(on: viewController, source: .camera)
        })
       
        actionSheet.addAction(.init(title: LocalizedString("receipt_attach_image"), style: .default) { [weak self] _ in
            self?.presentPicker(on: viewController, source: .photoLibrary)
        })
        
        actionSheet.addAction(.init(title: LocalizedString("DIALOG_CANCEL"), style: .cancel) { [weak self] _ in
            self?.singleObserver = nil
        })
        
        if let popover = actionSheet.popoverPresentationController {
            let view = viewController.view
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view!.bounds.midX, y: view!.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = .init(rawValue: 0)
        }
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
        return result()
    }
    
    func presentCamera(on viewController: UIViewController) -> Single<UIImage> {
        return presentPicker(on: viewController, source: .camera)
    }
    
    @discardableResult
    private func presentPicker(on viewController: UIViewController, source: UIImagePickerController.SourceType) -> Single<UIImage> {
        let picker = UIImagePickerController()
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            let title = LocalizedString("generic_error_alert_title")
            let message = LocalizedString("camera_permission_alert_message")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: nil)
            let settings = UIAlertAction(title: LocalizedString("camera_permission_alert_button"), style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            alert.addAction(cancel)
            alert.addAction(settings)
            
            viewController.present(alert, animated: true, completion: nil)
            return .never()
        }
        
        picker.delegate = self
        picker.sourceType = source
        
        viewController.present(picker, animated: true, completion: nil)
        
        return result()
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = info[.originalImage] as! UIImage
        chosenImage = WBImageUtils.processImage(chosenImage)
        chosenImage = WBImageUtils.compressImage(chosenImage, withRatio: COMPRESSION_RATIO)
        
        
        picker.dismiss(animated: true) {
            self.singleObserver?(.success(chosenImage))
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
