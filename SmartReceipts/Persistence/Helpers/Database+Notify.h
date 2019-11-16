//
//  Database+Notify.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@protocol FetchedModel;

@interface Database (Notify)

- (void)setNotificationsDisabled:(BOOL)disabled;
- (void)notifyInsertOfModel:(id<FetchedModel>)model;
- (void)notifyUpdateOfModel:(id<FetchedModel>)model;
- (void)notifyDeleteOfModel:(id<FetchedModel>)model;
- (void)notifyReorderOfModels:(NSArray *)models;
- (void)notifySwapOfModels:(NSArray *)models;
- (void)executeWithoutNotification:(void(^)(Database *))block;

@end
