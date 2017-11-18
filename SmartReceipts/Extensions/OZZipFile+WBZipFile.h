//
//  OZZipFile+WBZipFile.h
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import <objective_zip/OZZipFile.h>

@interface OZZipFile (WBZipFile)
+ (OZZipFile *)createWithFileName:(NSString *)filename mode:(OZZipFileMode)mode;
@end
