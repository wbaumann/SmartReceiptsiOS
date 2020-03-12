//
//  UIApplication+AppVersion.m
//  SmartReceipts
//
//  Created by Victor on 12/9/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

#import "UIApplication+AppVersion.h"

@implementation UIApplication (AppVersion)

- (NSString *)appVersionInfoString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ version %@, build %@\n", appDisplayName, appVersion, appBuildVersion];
}

- (NSString *)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
