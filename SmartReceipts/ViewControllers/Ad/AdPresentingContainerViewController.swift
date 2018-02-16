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
import Darwin

fileprivate let BANNER_HEIGHT: CGFloat = 50

class AdPresentingContainerViewController: UIViewController {
    @IBOutlet fileprivate var adContainerHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var bannerView: GADBannerView?
    @IBOutlet fileprivate var upsellBannerView: UpsellBannerAdView!
    @IBOutlet fileprivate var container: UIView!
    private let purchaseService = PurchaseService()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upsellBannerView.isHidden = true

        bannerView?.rootViewController = self
        bannerView?.adUnitID = AD_UNIT_ID
        bannerView?.delegate = self
        bannerView?.tintColor = AppTheme.accentColor
        
        checkAdsStatus()
        
        upsellBannerView.bannerTap.subscribe(onNext: { [unowned self] in
            _ = self.purchaseService.purchaseSubscription().subscribe()
        }).disposed(by: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkAdsStatus),
                    name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerView?.adSize = getAdSize()
    }
    
    private func loadAd() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "b5c0a5fccf83835150ed1fac6dd636e6"]
        bannerView?.adSize = getAdSize()
        bannerView?.load(request)
    }
    
    fileprivate func getAdSize() -> GADAdSize {
        let adSize = CGSize(width: view.bounds.width, height: BANNER_HEIGHT)
        return GADAdSizeFromCGSize(adSize)
    }
    
    @objc private func checkAdsStatus() {
        if Database.sharedInstance().hasValidSubscription() {
            Logger.debug("Remove Ads")
            
            adContainerHeight.constant = 0
            view.layoutSubviewsAnimated()
            bannerView?.removeFromSuperview()
        } else if arc4random() % 100 == 0 {
            // Show UpsellBannerAdView randomly (1/100 times)
            upsellBannerView.isHidden = false
            bannerView?.isHidden = true
        } else {
            loadAd()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdPresentingContainerViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.adSize = getAdSize()
        adContainerHeight.constant = BANNER_HEIGHT
        view.layoutSubviewsAnimated()
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
        upsellBannerView.isHidden = false
    }
}

class AdNavigationEntryPoint: UINavigationController {
     static fileprivate(set) var navigationController: UINavigationController?
    
    override func viewDidLoad() {
        let module = AppModules.trips.build()
        AdNavigationEntryPoint.navigationController = self
        show(module.view, sender: nil)
    }
}
