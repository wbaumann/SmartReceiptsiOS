//
//  NSString+Extensions.h
//  SmartReceipts
//
//  Created by Victor on 2/1/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

/// Chacks if it's safe to use range on string
- (BOOL)rangeExists:(NSRange)range;

@end
