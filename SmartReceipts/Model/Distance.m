//
//  Distance.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Distance.h"
#import "WBPrice.h"
#import "WBTrip.h"

@interface Distance ()

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong) NSDecimalNumber *distance;
@property (nonatomic, strong) WBPrice *rate;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, copy) NSString *comment;

@end

@implementation Distance

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment {
    self = [super init];
    if (self) {
        _trip = trip;
        _distance = distance;
        _rate = rate;
        _location = location;
        _date = date;
        _timeZone = timeZone;
        _comment = comment;
    }
    return self;
}

@end
