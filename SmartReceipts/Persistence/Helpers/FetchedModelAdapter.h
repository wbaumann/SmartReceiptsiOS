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
@class FMDatabase;

@interface FetchedModelAdapter : NSObject

@property (nonatomic, weak) id<FetchedModelAdapterDelegate> delegate;
@property (nonatomic, strong) Class modelClass;
@property (nonatomic, strong) NSObject *associatedModel;

- (id)objectAtIndex:(NSInteger)index;
- (id)initWithDatabase:(Database *)database;
- (NSUInteger)numberOfObjects;
- (void)setQuery:(NSString *)query;
- (void)setQuery:(NSString *)query parameters:(NSDictionary *)parameters;
- (void)fetch;
- (void)fetchUsingDatabase:(FMDatabase *)database;
- (NSArray *)allObjects;
- (NSUInteger)indexForObject:(id)object;

@end
