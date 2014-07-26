//
//  WBImageStampler.h
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBTrip.h"
#import "WBReceipt.h"

@interface WBImageStampler : NSObject

-(BOOL) zipToFile:(NSString*) outputPath stampedImagesForReceiptsAndIndexes:(NSArray*) receiptsAndIndexes inTrip:(WBTrip*) trip;

@end
