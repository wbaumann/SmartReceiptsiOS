//
//  WBAutocompleteHelper.h
//  SmartReceipts
//
//  Created on 08/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTAutocompleteTextField.h"
#import "CMPopTipView.h"

@interface WBAutocompleteHelper : NSObject<CMPopTipViewDelegate,HTAutocompleteDataSource,HTAutocompleteTextFieldDelegate>

- (id)initWithAutocompleteField:(HTAutocompleteTextField*) field inView:(UIView*) view useReceiptsHints:(BOOL) forReceipts;

-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;

@end
