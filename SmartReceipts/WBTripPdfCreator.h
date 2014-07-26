//
//  WBTripPdfCreator.h
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBTrip.h"
#import "WBColumnsResolver.h"

@interface WBTripPdfCreator : NSObject

-(id)initWithColumns:(NSArray*)columns columnsResolver:(WBColumnsResolver*)columnsResolver;

-(BOOL) createFullPdfFileAtPath:(NSString*) filePath receiptsAndIndexes:(NSArray*)receiptsAndIndexes trip:(WBTrip*) trip;

-(BOOL) createImagesPdfFileAtPath:(NSString*) filePath receiptsAndIndexes:(NSArray*)receiptsAndIndexes trip:(WBTrip*) trip;

@end
