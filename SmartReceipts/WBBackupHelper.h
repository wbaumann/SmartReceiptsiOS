//
//  WBBackupHelper.h
//  SmartReceipts
//
//  Created on 08/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBBackupHelper : NSObject<UIAlertViewDelegate>

-(NSString*) exportAll;
-(BOOL) importAllFrom:(NSString*) path overwrite:(BOOL) overwrite;

-(void) handleImport:(NSURL*) url;

+(BOOL) isDataBlocked;
+(void) setDataBlocked:(BOOL) blocked;

@end
