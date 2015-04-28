//
//  DatabaseTestsBase.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@interface DatabaseTestsBase : XCTestCase

@property (nonatomic, copy) NSString *testDBPath;

- (NSString *)generateTestDBPath;

@end
