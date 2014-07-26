//
//  WBImageSegue.m
//  SmartReceipts
//
//  Created on 10/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBImageSegue.h"

#import "WBReceiptActionsViewController.h"

@implementation WBImageSegue

-(void)perform {
    UIViewController *receiptsViewController = ((WBReceiptActionsViewController*)[self sourceViewController]).receiptsViewController;
    
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    UINavigationController *navigationController = receiptsViewController.navigationController;
    
    [[self sourceViewController] dismissViewControllerAnimated:YES completion:^{
        [navigationController pushViewController:destinationController animated:YES];
    }];
    
}

@end
