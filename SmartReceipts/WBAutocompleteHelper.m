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

@interface WBAutocompleteHelper () <SuggestionViewDelegate>

@property (weak, nonatomic) UITextField *field;
@property (strong, nonatomic) SuggestionView *suggestionView; // appears above keyboard
@property (assign, nonatomic) BOOL forReceipts;

@end

@implementation WBAutocompleteHelper

#pragma mark - Initialization

- (id)initWithAutocompleteField:(UITextField *)field useReceiptsHints:(BOOL)forReceipts
{
    self = [super init];
    if (self) {
        _field = field;
        _forReceipts = forReceipts;
        
        _suggestionView = [SuggestionView new];
        _suggestionView.maxSuggestionCount = 3;
        _suggestionView.delegate = self;
        
        self.field.inputAccessoryView = nil;
        [self.field setInputAccessoryView:nil];
        self.field.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.field reloadInputViews];
    }
    return self;
}

#pragma mark - Public methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _field) {
        [self showSuggestionView];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _field) {
        [self removeSuggestionView];
    }
}

- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _field) {
        // generate hints
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"%@", resultString);
        NSArray *hints = [self getHintsForPrefix:resultString];
        
        // show suggestions
        _suggestionView.suggestions = hints;
        // reloads _suggestionView:
        [self removeSuggestionView];
        [self showSuggestionView];
    }
}

#pragma mark - SuggestionView stuff

- (void)showSuggestionView {
    if (self.suggestionView.suggestions.count > 0) {
        self.field.inputAccessoryView = self.suggestionView;
        self.field.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.field reloadInputViews];
    }
}

- (void)removeSuggestionView {
    self.field.inputAccessoryView = nil;
    [self.field setInputAccessoryView:nil];
    self.field.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.field reloadInputViews];
    
    if ([self.field isFirstResponder]) {
        [self.field resignFirstResponder];
        // enables native OS autocompletion
        self.field.autocorrectionType = UITextAutocorrectionTypeYes;
        [self.field reloadInputViews];
        [self.field becomeFirstResponder];
    }
}

#pragma mark SuggestionViewDelegate

- (void)suggestionSelected:(NSString *)suggestion {
    self.field.text = suggestion;
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
