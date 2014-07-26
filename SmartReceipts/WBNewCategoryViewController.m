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

@interface WBNewCategoryViewController ()

@end

@implementation WBNewCategoryViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.category) {
        self.nameTextField.text = [self.category name];
        self.codeTextField.text = [self.category code];
    }
}

- (IBAction)actionDone:(id)sender {
    
    NSString* name = self.nameTextField.text;
    NSString* code = self.codeTextField.text;
    
    if ([name length]<=0) {
        [self showAlertWithTitle:nil message:NSLocalizedString(@"Please enter a name",nil)];
        return;
    }
    
    if (self.category) {
        if(![[WBDB categories] updateWithName:[self.category name] toName:name code:code]) {
            [self showAlertWithTitle:nil message:NSLocalizedString(@"Cannot edit this category",nil)];
            return;
        }
        
        WBCategory* category = [[WBCategory alloc] initWithName:name code:code];
        [self.delegate viewController:self updatedCategory:self.category toCategory:category];
        
    } else {
        if(![[WBDB categories] insertWithName:name code:code]) {
            [self showAlertWithTitle:nil message:NSLocalizedString(@"Cannot add this category",nil)];
            return;
        }
        
        WBCategory* category = [[WBCategory alloc] initWithName:name code:code];
        [self.delegate viewController:self newCategory:category];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString*) title message:(NSString*) message {
    [[[UIAlertView alloc]
      initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
}

@end
