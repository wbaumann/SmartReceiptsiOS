//
//  AdPresentingContainerViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import GoogleMobileAds

fileprivate let BANNER_HEIGHT: CGFloat = 80

class AdPresentingContainerViewController: UIViewController {
    @IBOutlet fileprivate var adContainerHeight: NSLayoutConstraint?
    @IBOutlet fileprivate var nativeExpressAdView: GADNativeExpressAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adContainerHeight?.constant = 0
        
        nativeExpressAdView?.rootViewController = self
        nativeExpressAdView?.adUnitID = AD_UNIT_ID
        nativeExpressAdView?.delegate = self
        
        DispatchQueue.main.async {
            self.loadAd()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadAd),
                    name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
    }
    
    
    @objc private func loadAd() {
        if !Database.sharedInstance().hasValidSubscription() {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID, "b5c0a5fccf83835150ed1fac6dd636e6"]
            nativeExpressAdView?.adSize = getAdSize()
            nativeExpressAdView?.load(request)
        }
    }
    
    fileprivate func getAdSize() -> GADAdSize {
        let adSize = CGSize(width: view.bounds.width, height: BANNER_HEIGHT)
        return GADAdSizeFromCGSize(adSize)
    }
    
    private func checkAdsStatus() {
        if Database.sharedInstance().hasValidSubscription() {
            Logger.debug("Remove ads")

            UIView.animate(withDuration: 0.3, animations: { 
                self.adContainerHeight?.constant = 0
                self.view.layoutSubviews()
            })
            
            nativeExpressAdView = nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdPresentingContainerViewController: GADNativeExpressAdViewDelegate {
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.adContainerHeight?.constant = BANNER_HEIGHT
            self.view.layoutSubviews()
        })
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.adContainerHeight?.constant = 0
            self.view.layoutSubviews()
        }) { _ in
            nativeExpressAdView.adSize = self.getAdSize()
        }
    }
}
