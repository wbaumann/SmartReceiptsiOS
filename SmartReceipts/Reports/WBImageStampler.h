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
- (BOOL)stampImagesForReceipts:(NSArray *_Nonnull)receipts inTrip:(WBTrip *_Nonnull)trip completion:(void(^_Nullable)(NSArray<NSURL *> * _Nonnull urls))completion;
@end
