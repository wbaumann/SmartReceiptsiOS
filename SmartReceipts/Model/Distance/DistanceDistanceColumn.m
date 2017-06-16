//
//  DistanceDistanceColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceDistanceColumn.h"

@implementation DistanceDistanceColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return [distance.distance descriptionWithLocale:[NSLocale currentLocale]];
}

@end
