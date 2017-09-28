//
//  main.m
//  SmartReceipts
//
//  Created on 11/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char * argv[])
{
    @autoreleasepool {
        Class delegateClass = NSClassFromString(@"WBTestAppDelegate");
        if (!delegateClass) {
            delegateClass = [AppDelegate class];
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(delegateClass));
    }
}
