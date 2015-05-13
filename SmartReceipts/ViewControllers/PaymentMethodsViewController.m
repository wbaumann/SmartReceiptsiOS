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
#import "EditPaymentMethodViewController.h"

NSString *const PushEditPaymentMethodSequeIdentifier = @"PushEditPaymentMethodSequeIdentifier";

@interface PaymentMethodsViewController ()

@property (nonatomic, strong) PaymentMethod *tapped;

@end

@implementation PaymentMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Payment Methods", nil)];

    [self setPresentationCellNib:[TitleOnlyCell viewNib]];

    [self setHidesBottomBarWhenPushed:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    TitleOnlyCell *titleCell = (TitleOnlyCell *) cell;
    PaymentMethod *method = object;
    [titleCell setTitle:method.method];
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] fetchedAdapterForPaymentMethods];
}

- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [[Database sharedInstance] deletePaymentMethod:object];
}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    [self setTapped:tapped];

    [self performSegueWithIdentifier:PushEditPaymentMethodSequeIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([PushEditPaymentMethodSequeIdentifier isEqualToString:segue.identifier]) {
        EditPaymentMethodViewController *controller = segue.destinationViewController;
        [controller setMethod:self.tapped];
        [self setTapped:nil];
    }
}

@end
