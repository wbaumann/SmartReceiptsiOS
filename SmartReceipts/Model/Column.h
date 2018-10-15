//
//  Column.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"

@class WBDateFormatter;

@interface Column : NSObject <FetchedModel>

@property (nonatomic) NSInteger objectId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger сolumnType;
@property (nonatomic, strong, readonly) WBDateFormatter *dateFormatter;
@property (nonatomic, readonly) NSString *header;
@property (nonatomic, strong) NSString *uniqueIdentity;
@property (nonatomic) NSInteger customOrderId;

- (instancetype)initWithIndex:(NSInteger)index type:(NSInteger)type name:(NSString *)name;
- (instancetype)initWithType:(NSInteger)type name:(NSString *)name;

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCSV;
- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV;

@end
