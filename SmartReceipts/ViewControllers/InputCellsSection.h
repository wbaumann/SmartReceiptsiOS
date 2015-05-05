//
//  InputCellsSection.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputCellsSection : NSObject

+ (InputCellsSection *)sectionWithCells:(NSArray *)cells;

- (NSUInteger)numberOfCells;
- (UITableViewCell *)cellAtIndex:(NSUInteger)index;
- (void)insertCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)removeCellAtIndex:(NSInteger)row;

@end
