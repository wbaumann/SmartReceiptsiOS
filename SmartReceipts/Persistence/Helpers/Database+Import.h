//
//  Database+Import.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@interface Database (Import)

- (BOOL)importDataFromBackup:(NSString *)filePath overwrite:(BOOL)overwrite;

@end
