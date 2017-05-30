//
//  InputCellsSection.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "InputCellsSection.h"

@interface InputCellsSection ()

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, copy) NSString *sectionTitle;

@end

@implementation InputCellsSection

+ (InputCellsSection *)sectionWithTitle:(NSString *)sectionTitle cells:(NSArray *)cells {
    InputCellsSection *section = [[InputCellsSection alloc] init];
    [section setSectionTitle:sectionTitle];
    [section setCells:cells];
    return section;
}

+ (InputCellsSection *)sectionWithCells:(NSArray *)cells {
    return [InputCellsSection sectionWithTitle:nil cells:cells];
}

- (NSUInteger)numberOfCells {
    return self.cells.count;
}

- (UITableViewCell *)cellAtIndex:(NSUInteger)index {
    return self.cells[index];
}

- (void)insertCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    NSMutableArray *presented = [NSMutableArray arrayWithArray:self.cells];
    [presented insertObject:cell atIndex:index];
    [self setCells:[NSArray arrayWithArray:presented]];
}

- (void)removeCellAtIndex:(NSInteger)row {
    NSMutableArray *presented = [NSMutableArray arrayWithArray:self.cells];
    [presented removeObjectAtIndex:row];
    [self setCells:[NSArray arrayWithArray:presented]];
}

@end
