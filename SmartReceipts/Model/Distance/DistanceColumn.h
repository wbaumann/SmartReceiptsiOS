//
//  DistanceColumn.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Column.h"

@class Distance;

@interface DistanceColumn : Column

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV;
+ (NSArray *)allColumns;

@end
