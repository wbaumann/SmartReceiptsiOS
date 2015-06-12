//
//  WBNoTripsViewController.m
//  SmartReceipts
//
//  Created on 23/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBNoTripsViewController.h"

@interface WBNoTripsViewController ()

@end

@implementation WBNoTripsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.labelNoReportSelected.text = NSLocalizedString(@"no.trips.empty.message", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
