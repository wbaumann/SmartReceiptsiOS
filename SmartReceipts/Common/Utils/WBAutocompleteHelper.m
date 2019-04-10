//
//  WBAutocompleteHelper.m
//  SmartReceipts
//
//  Created on 08/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBAutocompleteHelper.h"
#import "WBPreferences.h"
#import "Database+Hints.h"
#import "SuggestionView.h"
#import "NSString+Extensions.h"
#import <SmartReceipts-Swift.h>

@interface WBAutocompleteHelper () <SuggestionViewDelegate>

@property (weak, nonatomic) UITextField *field;
@property (strong, nonatomic) SuggestionView *suggestionView; // appears above keyboard
@property (assign, nonatomic) BOOL forReceipts;
@property (strong, nonatomic) NSArray *hints;

@end

@implementation WBAutocompleteHelper

#pragma mark - Initializatioz

- (id)initWithAutocompleteField:(UITextField *)field useReceiptsHints:(BOOL)forReceipts {
    self = [super init];
    if (self) {
        _field = field;
        _forReceipts = forReceipts;
        self.field.inputAccessoryView = nil;
        self.field.autocorrectionType = UITextAutocorrectionTypeYes;
        [self.field reloadInputViews];
    }
    return self;
}

- (SuggestionView *)suggestionView {
    if (_suggestionView) {
        return _suggestionView;
    } else {
        _suggestionView = [SuggestionView new];
        _suggestionView.maxSuggestionCount = 3;
        _suggestionView.delegate = self;
        return _suggestionView;
    }
}

#pragma mark - Public methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _field) {
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _field) {
        [self removeSuggestionView];
    }
}

- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField != _field) {
        return;
    }
    if (![textField.text rangeExists:range]) {
        return;
    }
    
    // generate hints
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.hints = [self getHintsForPrefix:resultString];
    
    // reloads suggestionView:
    [self removeSuggestionView];
    [self showSuggestionView];
}

#pragma mark - SuggestionView stuff

- (void)showSuggestionView {
    if (self.hints.count > 0) {
        self.suggestionView.suggestions = self.hints;
        if ([self.field isFirstResponder]) {
            self.field.inputAccessoryView = self.suggestionView;
            self.field.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.field reloadInputViews];
        }
    }
}

- (void)removeSuggestionView {
    // Prevent calling this multiple times
    if (![self.field.inputAccessoryView isEqual:self.suggestionView]) {
        return;
    }
    
    self.field.inputAccessoryView = nil;
    
    // enables native OS autocompletion
    if ([self.field isFirstResponder]) {
        _suggestionView = nil;
        self.field.inputAccessoryView = nil;
        self.field.autocorrectionType = UITextAutocorrectionTypeYes;
        [self.field reloadInputViews];
    }
}

#pragma mark SuggestionViewDelegate

- (void)suggestionSelected:(NSString *)suggestion {
    [self.delegate didSelectWithValue:[NSString stringWithFormat:@"%@ ", suggestion]];
    [self removeSuggestionView];
}

#pragma mark - Hints from DB

/// Returns @[NSString] or empty array @[] if no suggestions
- (NSArray *)getHintsForPrefix:(NSString *)prefix {
    Database *database = [Database sharedInstance];
    NSArray *hints = _forReceipts ? [database hintForReceiptBasedOnEntry:prefix] : [database hintForTripBasedOnEntry:prefix];
    return hints;
}

@end
