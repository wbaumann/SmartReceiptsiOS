//
//  DataImport.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataImport : NSObject

- (id)initWithInputFile:(NSString *)inputPath output:(NSString *)outputPath;
- (void)execute;

@end
