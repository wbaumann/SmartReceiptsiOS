//
//  FetchedModelAdapter+Testable.h
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import "FetchedModelAdapter.h"

@interface FetchedModelAdapter (Testable)
- (void)clearNotificationListener;
- (void)refreshContentAndNotifyUpdateChanges:(NSObject *)updated;
- (void)refreshContentAndNotifyDeleteChanges;
- (void)refreshContentAndNotifyInsertChanges;
- (void)refreshContentAndNotifySwapChanges:(NSArray *)swapped;
@end
