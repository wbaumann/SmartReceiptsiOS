//
//  AdPresentingContainerViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 21/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "AdPresentingContainerViewController.h"
#import "GADConstants.h"
#import "Constants.h"
#import "Database.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Database+Purchases.h"

#define BANNER_HEIGHT 80.0 // Default heigh of the banner

@interface AdPresentingContainerViewController () <GADNativeExpressAdViewDelegate>

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *adContainerHeight;
@property (nonatomic, weak) IBOutlet GADNativeExpressAdView *nativeExpressAdView;

@end

@implementation AdPresentingContainerViewController

#pragma mark - Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adContainerHeight.constant = 0;
    
    self.nativeExpressAdView.rootViewController = self;
    self.nativeExpressAdView.adUnitID = AD_UNIT_ID;
    self.nativeExpressAdView.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadAd];
    });
    
//    // TEST: hiding and appearing animation
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self nativeExpressAdView:self.nativeExpressAdView didFailToReceiveAdWithError:[GADRequestError new]];
//    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAdsStatus) name:SmartReceiptsAdsRemovedNotification object:nil];
}

#pragma mark - Ads stuff

/// Returns preffered ad size
- (GADAdSize)getAdSize {
    CGSize adSize = CGSizeMake(self.view.frame.size.width, BANNER_HEIGHT);
    return GADAdSizeFromCGSize(adSize);
}

- (void)checkAdsStatus {
    if (![Database sharedInstance].hasValidSubscription) {
        return;
    }
    
    LOGGER_DEBUG(@"Remove ads");
    [UIView animateWithDuration:0.3 animations:^{
        [self.adContainerHeight setConstant:0];
        [self.view layoutIfNeeded];
    }];
    self.nativeExpressAdView = nil;
}

- (void)loadAd {
    if ([Database sharedInstance].hasValidSubscription) {
        return;
    }

    GADRequest *request = [GADRequest request];
    [request setTestDevices:@[kGADSimulatorID, @"b5c0a5fccf83835150ed1fac6dd636e6"]];
    self.nativeExpressAdView.adSize = [self getAdSize];
    [self.nativeExpressAdView loadRequest:request];
}

#pragma mark - GADNativeExpressAdViewDelegate

- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView {
    [UIView animateWithDuration:0.3 animations:^{
        self.adContainerHeight.constant = BANNER_HEIGHT;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView didFailToReceiveAdWithError:(GADRequestError *)error {
    // hides banner and makes new request with preffered size
    [UIView animateWithDuration:0.3 animations:^{
        [self.adContainerHeight setConstant:0];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.nativeExpressAdView.adSize = [self getAdSize];
    }];
}

@end
