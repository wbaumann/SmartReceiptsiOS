//
//  WBReportUtils.h
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBReceipt.h"

@interface WBReportUtils : NSObject

+(BOOL) filterOutReceipt:(WBReceipt*) receipt;

@end
