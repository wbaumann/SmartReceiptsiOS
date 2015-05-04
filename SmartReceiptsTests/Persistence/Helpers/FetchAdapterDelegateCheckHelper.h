//
//  FetchAdapterDelegateCheckHelper.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 04/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModelAdapterDelegate.h"

@interface FetchAdapterDelegateCheckHelper : NSObject <FetchedModelAdapterDelegate>

@property (nonatomic, assign, readonly) BOOL willChangeCalled;
@property (nonatomic, assign, readonly) BOOL didChangeCalled;
@property (nonatomic, assign, readonly) NSUInteger insertIndex;
@property (nonatomic, strong, readonly) id insertObject;

@end
