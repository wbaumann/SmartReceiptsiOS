//
//  WBNewCategoryViewController.m
//  SmartReceipts
//
//  Created on 15/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBNewCategoryViewController.h"

#import "WBCategory.h"

#import "WBDB.h"
#import "Database+Categories.h"

@interface WBNewCategoryViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation WBNewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.category) {
        self.nameTextField.text = [self.category name];
        self.codeTextField.text = [self.category code];
    }
}

- (IBAction)actionDone:(id)sender {

    NSString *name = self.nameTextField.text;
    NSString *code = self.codeTextField.text;

    if ([name length] <= 0) {
        [self showAlertWithTitle:nil message:NSLocalizedString(@"Please enter a name", nil)];
        return;
    }

    if (self.category) {
        [self.category setName:name];
        [self.category setCode:code];
        if (![[Database sharedInstance] updateCategory:self.category]) {
            [self showAlertWithTitle:nil message:NSLocalizedString(@"Cannot edit this category", nil)];
            return;
        }
    } else {
        WBCategory *category = [[WBCategory alloc] initWithName:name code:code];
        if (![[Database sharedInstance] saveCategory:category]) {
            [self showAlertWithTitle:nil message:NSLocalizedString(@"Cannot add this category", nil)];
            return;
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc]
            initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

@end
