//
//  PaymentMethod.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"

@interface PaymentMethod : NSObject <FetchedModel>

@property (nonatomic, assign) NSUInteger objectId;
@property (nonatomic, copy) NSString *method;

@end
