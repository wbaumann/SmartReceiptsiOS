//
//  DataExport.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataExport : NSObject

- (id)initWithWorkDirectory:(NSString *)pathToDirectory;

- (NSString *)execute;

@end
