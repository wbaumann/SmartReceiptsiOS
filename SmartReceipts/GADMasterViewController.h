//
//  GADMasterViewController
//  SmartReceipts
//
//  Created on 27/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerViewDelegate.h"

@interface GADMasterViewController : UIViewController <GADBannerViewDelegate>

+(GADMasterViewController*) sharedInstance;
-(void)resetAdView:(UIViewController<GADBannerViewDelegate> *)rootViewController;
    
@end
