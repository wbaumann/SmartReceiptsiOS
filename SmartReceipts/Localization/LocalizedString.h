//
//  LocalizedString.h
//  SmartReceipts
//
//  Created by William Baumann on 10/12/18.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizedString(key, cmt) \
    [LocalizedString from:(key) comment:(cmt)]

#define Localized(key) \
    [LocalizedString from:(key) comment:(nil)]

@interface LocalizedString : NSObject

// Alters the tradition NSLocalizedString behavior to check that the key is in the
// Localizble.strings file OR the SharedLocalizable.strings file, where the latter
// contains strings that are shared with Android
+ (NSString*)from:(NSString*)key comment:(NSString*)comment;

@end
