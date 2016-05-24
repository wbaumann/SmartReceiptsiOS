//
//  InputCellsSection.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCellsSection : NSObject

@property (nonatomic, copy, readonly) NSString *__nullable sectionTitle;
@property (nonatomic, strong, readonly) NSArray<UITableViewCell *> *__nonnull cells;

+ (InputCellsSection *__nonnull)sectionWithTitle:(NSString *__nullable)sectionTitle cells:(NSArray<UITableViewCell *> *__nonnull)cells;
+ (InputCellsSection *__nonnull)sectionWithCells:(NSArray<UITableViewCell *> *__nonnull)cells;

- (NSUInteger)numberOfCells;
- (UITableViewCell *__nullable)cellAtIndex:(NSUInteger)index;
- (void)insertCell:(UITableViewCell *__nonnull)cell atIndex:(NSInteger)index;
- (void)removeCellAtIndex:(NSInteger)row;

@end
