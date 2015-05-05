//
//  DistanceLocationColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceLocationColumn.h"
#import "Distance.h"

@implementation DistanceLocationColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return distance.location;
}

@end
