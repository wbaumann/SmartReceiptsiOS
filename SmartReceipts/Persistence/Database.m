//
//  Database.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "Database.h"
#import "Constants.h"
#import "WBFileManager.h"
#import "DatabaseMigration.h"

@interface Database ()

@property (nonatomic, copy) NSString *pathToDatabase;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation Database

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (id)initSingleton {
    return [self initWithDatabasePath:[WBFileManager pathInDocuments:@"receipts.db"]];
}

- (id)initWithDatabasePath:(NSString *)path {
    self = [super init];
    if (self) {
        _pathToDatabase = path;
    }
    return self;
}

- (BOOL)open {
    return [self open:YES];
}

- (BOOL)open:(BOOL)migrateDatabase {
    FMDatabaseQueue *db = [FMDatabaseQueue databaseQueueWithPath:self.pathToDatabase];

    if (!db) {
        return NO;
    }

    [self setDatabaseQueue:db];

    if (!migrateDatabase) {
        return YES;
    }

    return [DatabaseMigration migrateDatabase:self];
}

- (void)close {
    [self.databaseQueue close];
}

@end
