//
//  FetchAdapterDelegateCheckHelper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 04/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import "FetchAdapterDelegateCheckHelper.h"

@interface FetchAdapterDelegateCheckHelper ()

@property (nonatomic, assign) BOOL willChangeCalled;
@property (nonatomic, assign) BOOL didChangeCalled;
@property (nonatomic, assign) NSUInteger insertIndex;
@property (nonatomic, assign) NSUInteger deleteIndex;
@property (nonatomic, assign) NSUInteger updateIndex;
@property (nonatomic, strong) id insertObject;
@property (nonatomic, strong) id deleteObject;
@property (nonatomic, strong) id updateObject;

@end

@implementation FetchAdapterDelegateCheckHelper

- (void)willChangeContent {
    [self setWillChangeCalled:YES];
}

- (void)didInsertObject:(id)object atIndex:(NSUInteger)index {
    [self setInsertObject:object];
    [self setInsertIndex:index];
}

- (void)didDeleteObject:(id)object atIndex:(NSUInteger)index {
    [self setDeleteObject:object];
    [self setDeleteIndex:index];
}

- (void)didUpdateObject:(id)object atIndex:(NSUInteger)index {
    [self setUpdateObject:object];
    [self setUpdateIndex:index];
}

- (void)didChangeContent {
    [self setDidChangeCalled:YES];
}

@end
