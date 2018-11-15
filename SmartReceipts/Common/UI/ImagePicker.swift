//
//  ImagePicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

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
        
        let title = LocalizedString("image.picker.sheet.title")
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel) { _ in
            self.singleObserver = nil
        }
        
        let library = UIAlertAction(title: LocalizedString("image.picker.sheet.choose.existing.button.title"), style: .default) { _ in
            self.presentPicker(on: viewController, source: .photoLibrary)
        }
        
        let photo = UIAlertAction(title: LocalizedString("image.picker.sheet.take.photo.button.title"), style: .default) { _ in
            self.presentPicker(on: viewController, source: .camera)
        }

        actionSheet.addAction(photo)
        actionSheet.addAction(library)
        actionSheet.addAction(cancel)
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
        return result()
    }
    
    func presentCamera(on viewController: UIViewController) -> Single<UIImage> {
        return presentPicker(on: viewController, source: .camera)
    }
    
    @discardableResult
    private func presentPicker(on viewController: UIViewController, source: UIImagePickerController.SourceType) -> Single<UIImage> {
        let picker = UIImagePickerController()
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
