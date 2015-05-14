//
//  TitledAutocompleteEntryCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 14/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TitledTextEntryCell.h"

@class WBAutocompleteHelper;

@interface TitledAutocompleteEntryCell : TitledTextEntryCell

@property (nonatomic, strong) WBAutocompleteHelper *autocompleteHelper;

@end
