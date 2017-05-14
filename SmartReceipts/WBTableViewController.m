//
//  WBTableViewController.m
//  SmartReceipts
//
//  Created on 17/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import "WBCustomization.h"

@interface WBTableViewController ()

@end

@implementation WBTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
