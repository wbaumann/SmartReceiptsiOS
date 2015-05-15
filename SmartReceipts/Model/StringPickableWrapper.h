//
//  StringPickableWrapper.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 14/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pickable.h"

@interface StringPickableWrapper : NSObject <Pickable>

+ (NSArray *)wrapValues:(NSArray *)values;
+ (StringPickableWrapper *)wrapValue:(NSString *)value;

@end
