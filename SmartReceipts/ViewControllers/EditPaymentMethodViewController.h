//
//  EditPaymentMethodViewController.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellsViewController.h"

@class PaymentMethod;

@interface EditPaymentMethodViewController : InputCellsViewController

@property (nonatomic, strong) PaymentMethod *method;

@end
