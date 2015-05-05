//
//  Column.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBDateFormatter;

@interface Column : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) WBDateFormatter *dateFormatter;

- (instancetype)initWithIndex:(NSInteger)index name:(NSString *)name;

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCSV;

@end
