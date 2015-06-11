//
//  EditPaymentMethodViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import "EditPaymentMethodViewController.h"
#import "PaymentMethod.h"
#import "EntryOnlyCell.h"
#import "UIView+LoadHelpers.h"
#import "UITableViewCell+Identifier.h"
#import "InputCellsSection.h"
#import "NSString+Validation.h"
#import "Database.h"
#import "Database+PaymentMethods.h"

@interface EditPaymentMethodViewController ()

@property (nonatomic, strong) EntryOnlyCell *entryCell;

@end

@implementation EditPaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.method) {
        [self.navigationItem setTitle:NSLocalizedString(@"edit.payment.method.controller.edit.title", nil)];
    } else {
        [self.navigationItem setTitle:NSLocalizedString(@"edit.payment.method.controller.add.title", nil)];
    }

    [self.tableView registerNib:[EntryOnlyCell viewNib] forCellReuseIdentifier:[EntryOnlyCell cellIdentifier]];
    self.entryCell = [self.tableView dequeueReusableCellWithIdentifier:[EntryOnlyCell cellIdentifier]];
    [self.entryCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    [self addSectionForPresentation:[InputCellsSection sectionWithCells:@[self.entryCell]]];
}

- (IBAction)donePressed {
    NSString *entry = [self.entryCell value];
    if (!entry.hasValue) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"edit.payment.method.controller.save.error.title", nil)
                                                            message:NSLocalizedString(@"edit.payment.method.controller.save.error.message", nil)
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                                   otherButtonItems:nil];
        [alertView show];
        return;
    }

    if ([[Database sharedInstance] hasPaymentMethodWithName:entry]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"edit.payment.method.controller.save.error.title", nil)
                                                            message:NSLocalizedString(@"edit.payment.method.controller.save.error.exists.message", nil)
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                                   otherButtonItems:nil];
        [alertView show];
        return;
    }

    if (!self.method) {
        self.method = [[PaymentMethod alloc] init];
    }

    [self.method setMethod:entry];

    if (self.method.objectId == 0 && [[Database sharedInstance] savePaymentMethod:self.method]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([[Database sharedInstance] updatePaymentMethod:self.method]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"edit.payment.method.controller.save.error.title", nil)
                                                            message:NSLocalizedString(@"edit.payment.method.controller.save.error.generic.message", nil)
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                                   otherButtonItems:nil];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.entryCell setText:self.method ? self.method.method : @""];
    [self.entryCell.entryField becomeFirstResponder];
}


@end
