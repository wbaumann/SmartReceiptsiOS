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
#import "NumberInputValidation.h"

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UITextField *entryField;

@end

@implementation TextEntryCell

- (NSString *)value {
    return [self.entryField text];
}

- (void)activateDecimalEntryMode {
    [self activateDecimalEntryModeWithDecimalPlaces:2];
}

- (void)activateDecimalEntryModeWithDecimalPlaces:(NSUInteger)decimalPlaces {
    [self addAccessoryView];
    [self.entryField setKeyboardType:UIKeyboardTypeDecimalPad];

    [self setInputValidation:[[DecimalInputValidation alloc] initWithNumberOfDecimalPlaces:decimalPlaces]];
}

- (void)activateNumberEntryMode {
    [self addAccessoryView];

    [self.entryField setKeyboardType:UIKeyboardTypeNumberPad];

    [self setInputValidation:[[NumberInputValidation alloc] init]];
}

- (void)addAccessoryView {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:@[spacer, doneButton]];

    [self.entryField setInputAccessoryView:toolbar];
}

- (void)activateEmailMode {
    [self.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
}

- (void)setValue:(NSString *)value {
    [self.entryField setText:value];
}

- (void)donePressed {
    [self.entryField.delegate textFieldShouldReturn:self.entryField];
}

@end
