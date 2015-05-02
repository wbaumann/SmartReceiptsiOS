//
//  FetchedModelAdapter.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "FetchedModelAdapter.h"
#import "Database.h"
#import "FMDatabase.h"
#import "FetchedModel.h"
#import "Constants.h"

@interface FetchedModelAdapter ()

@property (nonatomic, strong) Database *database;
@property (nonatomic, copy) NSString *fetchQuery;
@property (nonatomic, strong) NSDictionary *fetchParameters;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation FetchedModelAdapter

- (id)initWithDatabase:(Database *)database {
    self = [super init];
    if (self) {
        _database = database;
    }
    return self;
}

- (id)objectAtIndex:(NSInteger)index {
    return self.models[index];
}

- (NSUInteger)numberOfObjects {
    return self.models.count;
}

- (void)setFetchQuery:(NSString *)query parameters:(NSDictionary *)parameters {
    [self setFetchQuery:query];
    [self setFetchParameters:parameters];
}

- (void)fetch {
    NSMutableArray *objects = [NSMutableArray array];
    SRLog(@"Fetch query: '%@'", self.fetchQuery);
    SRLog(@"Fetch params: %@", self.fetchParameters);
    [self.database.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:self.fetchQuery withParameterDictionary:self.fetchParameters];
        while ([resultSet next]) {
            id<FetchedModel> fetched = (id <FetchedModel>) [[self.modelClass alloc] init];
            [fetched loadDataFromResultSet:resultSet];
            [objects addObject:fetched];
        }
    }];
    [self setModels:[NSMutableArray arrayWithArray:objects]];
}

@end
