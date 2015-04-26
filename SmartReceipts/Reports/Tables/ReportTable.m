//
//  ReportTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportTable.h"
#import "Constants.h"

@interface ReportTable ()

@property (nonatomic, strong) NSArray *columns;

@end

@implementation ReportTable

- (instancetype)initWithColumns:(NSArray *)columns {
    self = [super init];
    if (self) {
        _columns = columns;
    }
    return self;
}

- (void)appendTableWithRows:(NSArray *)rows {
    ABSTRACT_METHOD
}

@end
