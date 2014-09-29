//
//  GADMasterViewController.m
//  SmartReceipts
//
//  Created by William Baumann on 9/27/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "GADMasterViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GADConstants.h"

@implementation GADMasterViewController {
    GADBannerView *_adBanner;
    UIViewController<GADBannerViewDelegate>* _currentDelegate;
    BOOL _hasLoaded;
}

+(GADMasterViewController *)sharedInstance {
    static dispatch_once_t pred;
    static GADMasterViewController *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[GADMasterViewController alloc] init];
    });
    return shared;
}

-(id)init {
    if (self = [super init]) {
        _adBanner = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.0,
                                              0.0,
                                              GAD_SIZE_320x50.width,
                                              GAD_SIZE_320x50.height)];
        // Has an ad request already been made
        _hasLoaded = NO;
    }
    return self;
}

-(void)resetAdView:(UIViewController<GADBannerViewDelegate> *)rootViewController {
    // Always keep track of currentDelegate for notification forwarding
    _currentDelegate = rootViewController;
    
    // Ad already requested, simply add it into the view
    if (_hasLoaded) {
        [self adViewDidReceiveAd:_adBanner];
    } else {
        
        _adBanner.delegate = self;
        _adBanner.rootViewController = rootViewController;
        _adBanner.adUnitID = AD_UNIT_ID;
        
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ GAD_SIMULATOR_ID ];
        [_adBanner loadRequest:request];
        _hasLoaded = YES;
    }
}



- (void)adViewDidReceiveAd:(GADBannerView *)view {
    // Make sure that the delegate actually responds to this notification
    if (_currentDelegate) {
        [_currentDelegate adViewDidReceiveAd:view];
    }
}

@end