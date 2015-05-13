//
//  PaymentMethodsViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PaymentMethodsViewController.h"
#import "TitleOnlyCell.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database.h"
#import "Database+PaymentMethods.h"
#import "PaymentMethod.h"

@interface PaymentMethodsViewController ()

@end

@implementation PaymentMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Payment Methods", nil)];

    [self setPresentationCellNib:[TitleOnlyCell viewNib]];

    [self.navigationController setToolbarHidden:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    TitleOnlyCell *titleCell = (TitleOnlyCell *) cell;
    PaymentMethod *method = object;
    [titleCell setTitle:method.method];
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] fetchedAdapterForPaymentMethods];
}

@end
