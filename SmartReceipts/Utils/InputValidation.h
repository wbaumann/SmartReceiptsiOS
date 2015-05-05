//
//  InputValidation.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@protocol InputValidation <NSObject>

- (BOOL)isValidInput:(NSString *)input;

@end