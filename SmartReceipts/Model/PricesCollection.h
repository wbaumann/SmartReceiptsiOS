//
//  PricesCollection.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Price.h"

@interface PricesCollection : Price

- (void)addPrice:(Price *)price;
- (void)subtractPrice:(Price *)price;

@end
