//
//  TextEntryCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TextEntryCell.h"
#import "InputValidation.h"
#import "DecimalInputValidation.h"

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, strong) id<InputValidation> inputValidation;

@end

@implementation TextEntryCell

- (NSString *)value {
    return [self.entryField text];
}

- (void)activateDecimalEntryMode {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:@[spacer, doneButton]];

    [self.entryField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.entryField setInputAccessoryView:toolbar];

    [self setInputValidation:[[DecimalInputValidation alloc] init]];
}

- (void)donePressed {
    [self.entryField.delegate textFieldShouldReturn:self.entryField];
}

@end
