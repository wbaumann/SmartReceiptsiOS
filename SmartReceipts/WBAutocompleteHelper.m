//
//  WBAutocompleteHelper.m
//  SmartReceipts
//
//  Created on 08/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBAutocompleteHelper.h"

#import "WBDB.h"
#import "WBPreferences.h"
#import "Database+Hints.h"

@implementation WBAutocompleteHelper
{
    CMPopTipView *_popTipView;
    
    BOOL _didAutocomplete;
    BOOL _forReceipts;
    
    __weak UIView *_view;
    __weak HTAutocompleteTextField *_field;
}

- (id)initWithAutocompleteField:(HTAutocompleteTextField*) field inView:(UIView*) view useReceiptsHints:(BOOL) forReceipts
{
    self = [super init];
    if (self) {
        _field = field;
        _view = view;
        _forReceipts = forReceipts;
        
        _didAutocomplete = false;
        
        if([WBPreferences enableAutoCompleteSuggestions]) {
            field.autocompleteDataSource = self;
            field.autoCompleteTextFieldDelegate = self;
        }
    }
    return self;
}

-(NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {
    if (_didAutocomplete || ![WBPreferences enableAutoCompleteSuggestions]) {
        return @"";
    }

    Database *database = [Database sharedInstance];
    NSString *hint = _forReceipts ? [database hintForReceiptBasedOnEntry:prefix] : [database hintForTripBasedOnEntry:prefix];
    if (!hint) {
        return @"";
    }

    if ([prefix length] >= [hint length]) {
        return @"";
    }

    return [hint substringFromIndex:[prefix length]];
}

-(void)autoCompleteTextFieldDidAutoComplete:(HTAutocompleteTextField *)autoCompleteField{
    _didAutocomplete = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_didAutocomplete && textField == _field) {
        [self showPopTipViewIfNotShown];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _field) {
        [self hidePopTipView];
    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self hidePopTipView];
}

- (void) hidePopTipView {
    [_popTipView dismissAnimated:YES];
    _popTipView = nil;
}

- (void) showPopTipViewIfNotShown {
    if (_popTipView || ![WBPreferences enableAutoCompleteSuggestions]) {
        // we don't show them again when disabled
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    NSString *str = NSLocalizedString(@"You can also disable autocomplete if you'd prefer", nil);
    
    [label setFont:[UIFont systemFontOfSize:13.0]];
    [label setText:str];
    [label sizeToFit];
    
    CGRect r = label.frame;
    CGFloat h = MAX(r.size.height, sw.frame.size.height);
    r = CGRectMake(sw.frame.size.width + 10, 0, r.size.width, h);
    [label setFrame:r];
    
    [view addSubview:sw];
    [view addSubview:label];
    
    sw.on = YES;
    [sw addTarget:self action:@selector(autocompletionSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [view setFrame:CGRectMake(0, 0, r.origin.x + r.size.width, h)];
    
    _popTipView = [[CMPopTipView alloc] initWithCustomView:view];
    _popTipView.backgroundColor = [UIColor whiteColor];
    _popTipView.borderColor = [UIColor lightGrayColor];
    [_popTipView presentPointingAtView:_field inView:_view animated:YES];
}

- (void) autocompletionSwitchChanged:(id)sender{
    if([sender isOn] == false){
        [WBPreferences setEnableAutoCompleteSuggestions:NO];
        [self hidePopTipView];
    }
}

@end
