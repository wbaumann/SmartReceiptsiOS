//
//  Database+Notify.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Notify.h"
#import "FetchedModel.h"

@implementation Database (Notify)

- (void)notifyInsertOfModel:(id <FetchedModel>)model {
    [self postNotificationWithName:DatabaseDidInsertModelNotification withObject:model];
}

- (void)notifyUpdateOfModel:(id <FetchedModel>)model {
    [self postNotificationWithName:DatabaseDidUpdateModelNotification withObject:model];
}

- (void)notifyDeleteOfModel:(id <FetchedModel>)model {
    [self postNotificationWithName:DatabaseDidDeleteModelNotification withObject:model];
}

- (void)postNotificationWithName:(NSString *)notificationName withObject:(id<FetchedModel>)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:model];
    });
}

@end
