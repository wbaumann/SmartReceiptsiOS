//
//  EditDistanceView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol EditDistanceViewInterface {
    func setup(trip: WBTrip, distance: Distance?)
}

//MARK: EditDistance View
final class EditDistanceView: UserInterface {
    
    private var formView: EditDistanceFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView = EditDistanceFormView(trip: displayData.trip!, distance: displayData.distance)
        
        addChild(formView)
        formView.view.frame = view.bounds
        view.addSubview(formView.view)
        setupInitialState()
    }
    
    private func setupInitialState() {
        let isEdit = displayData.distance != nil
        
        navigationItem.title = isEdit ?
            LocalizedString("dialog_mileage_title_update") :
            LocalizedString("dialog_mileage_title_create")
    }
    
    //MARK: Actions
    @IBAction private func onSaveTap() {
        let errorsDescription = formView.validate()
        if errorsDescription.isEmpty {
            let distance = formView!.changedDistance!
            presenter.save(distance: distance, asNewDistance: displayData.distance == nil)
        } else {
            let title = LocalizedString("edit.distance.controller.validation.error.title")
            let alert = UIAlertController(title: title, message: errorsDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedString("generic_button_title_ok"), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - Public interface
extension EditDistanceView: EditDistanceViewInterface {
    func setup(trip: WBTrip, distance: Distance?) {
        displayData.trip = trip
        displayData.distance = distance
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistanceView {
    var presenter: EditDistancePresenter {
        return _presenter as! EditDistancePresenter
    }
    var displayData: EditDistanceDisplayData {
        return _displayData as! EditDistanceDisplayData
    }
}
