//
//  AdPresentingContainerViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 21/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "AdPresentingContainerViewController.h"
#import "GADConstants.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdPresentingContainerViewController () <GADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *adContainerView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *adContainerHeight;
@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation AdPresentingContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = AD_UNIT_ID;
    self.bannerView.rootViewController = self;
    [self.bannerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.adContainerView addSubview:self.bannerView];
    [self.bannerView setDelegate:self];

    [self.adContainerHeight setConstant:0];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadAd];
    });
}

- (void)loadAd {
    GADRequest *request = [GADRequest request];
    [request setTestDevices:@[kGADSimulatorID]];
    [self.bannerView loadRequest:request];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        self.adContainerHeight.constant = CGRectGetHeight(view.frame);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.bannerView setCenter:CGPointMake(CGRectGetWidth(self.adContainerView.frame) / 2, CGRectGetHeight(self.adContainerView.frame) / 2)];
    }];

}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [UIView animateWithDuration:0.3 animations:^{
        [self.adContainerHeight setConstant:0];
        [self.view layoutIfNeeded];
    }];
}

@end
