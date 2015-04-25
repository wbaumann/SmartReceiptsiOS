//
//  ReportTable.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportTable : NSObject

@property (nonatomic, assign) BOOL includeHeaders;

- (void)generateTableWithColumns:(NSArray *)columns;

@end
