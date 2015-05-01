//
//  Distance.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <libxml/SAX.h>
#import "Distance.h"
#import "WBCurrency.h"
#import "WBPrice.h"

@interface Distance ()

@property (nonatomic, strong) NSDecimalNumber *distance;
@property (nonatomic, strong) WBPrice *rate;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *comment;

@end

@implementation Distance

- (id)initWithDistance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date comment:(NSString *)comment {
    self = [super init];
    if (self) {
        _distance = distance;
        _rate = rate;
        _location = location;
        _date = date;
        _comment = comment;
    }
    return self;
}

@end
