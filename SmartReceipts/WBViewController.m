//
//  WBViewController.m
//  SmartReceipts
//
//  Created on 17/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"

#import "WBCustomization.h"

@interface WBViewController ()

@end

@implementation WBViewController

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
    [WBCustomization customizeOnViewDidLoad:self];
}

@end
