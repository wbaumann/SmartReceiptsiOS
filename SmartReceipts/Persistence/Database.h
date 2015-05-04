//
//  Database.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

extern NSString *const DatabaseDidInsertModelNotification;

@interface Database : NSObject

@property (nonatomic, strong, readonly) FMDatabaseQueue *databaseQueue;

+ (instancetype)sharedInstance;

- (BOOL)open;
- (void)close;

@end
