//
//  Column.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Column.h"
#import "WBDateFormatter.h"
#import "Constants.h"

@interface Column ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;

@end

@implementation Column

- (instancetype)initWithIndex:(NSInteger)index name:(NSString *)name {
    self = [super init];
    if (self) {
        _index = index;
        _name = name;
    }
    return self;
}

- (WBDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[WBDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
    return nil;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
    return nil;
}

- (NSString *)header {
    return self.name;
}

@end
