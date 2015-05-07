//
//  WBPreferencesTestHelper.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "WBPreferences.h"

@interface WBPreferencesTestHelper : WBPreferences

- (void)createPreferencesBackup;
- (void)restorePreferencesBackup;

@end
