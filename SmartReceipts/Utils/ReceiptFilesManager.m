//
//  ReceiptFilesManager.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptFilesManager.h"

@interface ReceiptFilesManager ()

@property (nonatomic, copy) NSString *pathToTripsFolder;

@end

@implementation ReceiptFilesManager

- (id)initWithTripsFolder:(NSString *)pathToTripsFolder {
    if (self) {
        _pathToTripsFolder = pathToTripsFolder;
    }
    return self;
}

@end
