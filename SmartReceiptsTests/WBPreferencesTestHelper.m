//
//  WBPreferencesTestHelper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "WBPreferencesTestHelper.h"

@interface WBPreferencesTestHelper ()

@property (nonatomic, copy) NSString *backup;

@end

@implementation WBPreferencesTestHelper

- (void)createPreferencesBackup {
    self.backup = [WBPreferences xmlString];
}

- (void)restorePreferencesBackup {
    [WBPreferences setFromXmlString:self.backup];
}

@end
