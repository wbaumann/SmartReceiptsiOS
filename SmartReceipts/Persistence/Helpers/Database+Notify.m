//
//  Database+Notify.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Notify.h"
#import "FetchedModel.h"

@interface Database (Expose)

@property (nonatomic, assign) BOOL disableNotifications;

@end

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

- (void)notifyReorderOfModels:(NSArray *)models {
    [self postNotificationWithName:DatabaseDidReorderModelsNotification withObjects:models];
}

- (void)notifySwapOfModels:(NSArray *)models {
    [self postNotificationWithName:DatabaseDidSwapModelsNotification withObjects:models];
}

- (void)postNotificationWithName:(NSString *)notificationName withObjects:(NSArray *)models {
    if (self.disableNotifications) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:models];
    });
}

- (void)postNotificationWithName:(NSString *)notificationName withObject:(id<FetchedModel>)model {
    if (self.disableNotifications) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:model];
    });
}

@end
