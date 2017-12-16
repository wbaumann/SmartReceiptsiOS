//
//  AdPresentingContainerViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import GoogleMobileAds
import Viperit
import RxSwift

fileprivate let BANNER_HEIGHT: CGFloat = 80

class AdPresentingContainerViewController: UIViewController {
    @IBOutlet fileprivate var adContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var nativeExpressAdView: GADNativeExpressAdView!
    @IBOutlet var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nativeExpressAdView.rootViewController = self
        nativeExpressAdView.adUnitID = AD_UNIT_ID
        nativeExpressAdView.delegate = self
        nativeExpressAdView.tintColor = AppTheme.accentColor
        
        checkAdsStatus()
        loadAd()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkAdsStatus),
                    name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
    }
    
    
     private func loadAd() {
        if !Database.sharedInstance().hasValidSubscription() {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID, "b5c0a5fccf83835150ed1fac6dd636e6"]
            nativeExpressAdView.adSize = getAdSize()
            nativeExpressAdView.load(request)
        }
    }
    
    fileprivate func getAdSize() -> GADAdSize {
        let adSize = CGSize(width: view.bounds.width, height: BANNER_HEIGHT)
        return GADAdSizeFromCGSize(adSize)
    }
    
    @objc private func checkAdsStatus() {
        if Database.sharedInstance().hasValidSubscription() {
            Logger.debug("Remove ads")
            adContainerHeight.constant = 0
            view.layoutSubviewsAnimated()
            nativeExpressAdView.delegate = nil
            nativeExpressAdView = nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdPresentingContainerViewController: GADNativeExpressAdViewDelegate {
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        adContainerHeight.constant = BANNER_HEIGHT
        view.layoutSubviewsAnimated()
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        adContainerHeight.constant = 0
        view.layoutSubviewsAnimated()
        nativeExpressAdView.adSize = getAdSize()
    }
}

class AdNavigationEntryPoint: UINavigationController {
    override func viewDidLoad() {
        let module = AppModules.trips.build()
        show(module.view, sender: nil)
    }
}
