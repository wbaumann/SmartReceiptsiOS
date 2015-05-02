//
//  FetchedModelAdapter.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchedModelAdapterDelegate;
@class Database;

@interface FetchedModelAdapter : NSObject

@property (nonatomic, weak) id<FetchedModelAdapterDelegate> delegate;
@property (nonatomic, strong) Class modelClass;

- (id)objectAtIndex:(NSInteger)index;
- (id)initWithDatabase:(Database *)database;
- (NSUInteger)numberOfObjects;
- (void)setFetchQuery:(NSString *)query parameters:(NSDictionary *)parameters;
- (void)fetch;

@end
