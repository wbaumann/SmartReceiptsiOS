//
//  InputCellsSection.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputCellsSection : NSObject

@property (nonatomic, copy, readonly) NSString *sectionTitle;

+ (InputCellsSection *)sectionWithTitle:(NSString *)sectionTitle cells:(NSArray *)cells;
+ (InputCellsSection *)sectionWithCells:(NSArray *)cells;

- (NSUInteger)numberOfCells;
- (UITableViewCell *)cellAtIndex:(NSUInteger)index;
- (void)insertCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)removeCellAtIndex:(NSInteger)row;

@end
