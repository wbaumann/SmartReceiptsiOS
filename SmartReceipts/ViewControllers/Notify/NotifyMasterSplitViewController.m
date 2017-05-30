//
//  NotifyMasterSplitViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NotifyMasterSplitViewController.h"

@interface NotifyMasterSplitViewController ()

@end

@implementation NotifyMasterSplitViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self.viewControllers firstObject] viewWillAppear:animated];
}

@end
