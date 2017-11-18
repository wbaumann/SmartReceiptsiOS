//
//  OZZipFile+WBZipFile.m
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import "OZZipFile+WBZipFile.h"
#import <objective_zip/OZZipFile+Standard.h>

@implementation OZZipFile (WBZipFile)
+ (OZZipFile * _Nullable)createWithFileName:(NSString *)filename mode:(OZZipFileMode)mode {
    @try {
        return [[OZZipFile alloc] initWithFileName:filename mode:mode];
    } @catch (NSException *exception) {
        return nil;
    }
}
@end
