//
//  SettingsViewController.h
//  SmartReceipts
//
//  Created on 13/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "InputCellsViewController.h"

@interface SettingsViewController : InputCellsViewController

@property (nonatomic, strong, nullable) UIDocumentInteractionController *documentInteractionController;

// YES if settingsVC was called from WBGenerateVC
// default is nil, not a garbage (means 'NO')
@property (nonatomic, assign) BOOL wasPresentedFromGeneratorVC;

@end
